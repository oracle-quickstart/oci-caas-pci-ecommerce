package com.oci.caas.pciecommerce.rest;


import com.oci.caas.pciecommerce.model.User;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import oracle.jdbc.*;

@Controller
public class OrderRestController {

    @Autowired
    JdbcTemplate jdbcTemplate;

    static class ItemOrder {
        private String name;
        private long id;
        private int count;
        private double price;
        public double getPrice() {
            return price;
        }
        public int getCount() {
            return count;
        }
        public long getId() {
            return id;
        }
        public String getName() {
            return name;
        }
    }

    static class OrderBody {
        private ItemOrder[] items;
        public ItemOrder[] getItems() {
            return items;
        }
    }

    static class CreatePaymentResponse {
        private String publishableKey;
        private String clientSecret;

        public CreatePaymentResponse(String publishableKey, String clientSecret) {
            this.publishableKey = publishableKey;
            this.clientSecret = clientSecret;
        }

        public String getClientSecret() {
            return clientSecret;
        }
        public void setClientSecret(String clientSecret) {
            this.clientSecret = clientSecret;
        }
        public String getPublishableKey() {
            return publishableKey;
        }
        public void setPublishableKey(String publishableKey) {
            this.publishableKey = publishableKey;
        }
    }

    private double calculateOrderAmount(ItemOrder[] items) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Object myUser = (auth != null) ? auth.getPrincipal() :  null;

        long uid = -1;
        if (myUser instanceof User) {
            User user = (User) myUser;
            uid = user.getUser_id();
        }

        int itemCount = items.length;
        int[] il_in = new int[itemCount];
        int[] ic_in = new int[itemCount];
        ArrayList<Integer> il = new ArrayList<Integer>(itemCount);
        ArrayList<Integer> ic = new ArrayList<Integer>(itemCount);

        double total = 0;
        for (int i = 0; i < itemCount; i++) {
//            il_in[i] = (int) items[i].getId();
            il.add((int) items[i].getId());
//            ic_in[i] = items[i].getCount();
            ic.add(items[i].getCount());

            total += items[i].getPrice() * items[i].getCount();
        }

//        System.out.println("total " + total);
//        for (int i: il) {
//            System.out.println("il: " + i);
//        }
//        for (int j: ic) {
//            System.out.println("ic: " + j);
//        }

        SimpleJdbcCall simpleJdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("createCart")
                .declareParameters(
                        new SqlParameter("uid_in", OracleTypes.INTEGER),
                        new SqlParameter("il_in", OracleTypes.ARRAY, "ECOM.ItemIds"),
                        new SqlParameter("ic_in", OracleTypes.ARRAY, "ECOM.ItemCounts"),
                        new SqlOutParameter("cartid_out", OracleTypes.INTEGER),
                        new SqlOutParameter("total_out", OracleTypes.DECIMAL));

        Map<String, Object> inParamMap = new HashMap<String, Object>();
        inParamMap.put("uid_in", uid);
        inParamMap.put("il_in", il);
        inParamMap.put("ic_in", ic);
        SqlParameterSource in = new MapSqlParameterSource(inParamMap);


        Map<String, Object> rs = simpleJdbcCall.execute(in);
//        System.out.println((int) rs.get("cartid_out"));
//        System.out.println((double) rs.get("total_out"));

//        Connection con = null;
//        try {
//            con = jdbcTemplate.getDataSource().getConnection();
//        } catch (SQLException throwables) {
//            throwables.printStackTrace();
//        }
//        oracle.jdbc.OracleConnection oraConn = (oracle.jdbc.OracleConnection) con;
//        java.sql.Array sqlArray = oraConn.createARRAY("typeName", array);

        return total * 100;
    }



    @PostMapping(value = "/process-order", produces = "application/json")
    @ResponseBody
    public TestRestController.CreatePaymentResponse secret(@RequestBody OrderBody postBody) throws StripeException {
        String private_key = System.getenv("STRIPE_SECRET_KEY");
        String public_key = System.getenv("STRIPE_PUBLISHABLE_KEY");
        Stripe.apiKey = private_key;


        PaymentIntentCreateParams createParams = new PaymentIntentCreateParams.Builder()
                .setCurrency("usd")
                .setAmount(new Long((long) calculateOrderAmount(postBody.getItems())))
                .build();

        PaymentIntent intent = PaymentIntent.create(createParams);

        TestRestController.CreatePaymentResponse paymentResponse = new TestRestController.CreatePaymentResponse(public_key, intent.getClientSecret());
        return paymentResponse;
    }
}
