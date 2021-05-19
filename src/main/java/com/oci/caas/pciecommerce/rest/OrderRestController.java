package com.oci.caas.pciecommerce.rest;

import com.oci.caas.pciecommerce.model.User;
import com.oci.caas.pciecommerce.model.Order;
import com.oci.caas.pciecommerce.model.OrderRowMapper;


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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.util.*;

import oracle.jdbc.OracleTypes;

/**
 * Rest Controller to receive requests related orders.
 * Includes controller to create a shopping cart and submitting
 * a payment to Stripe and saving it to database.
 */
@Controller
public class OrderRestController {

    @Autowired
    JdbcTemplate jdbcTemplate;

    /**
     * Represents the individual item in the shopping cart
     * Contained within the ItemOrderArray class that is received
     * on the /process-order call
     * @TODO Use the Item class instead of static class
     */
    static class ItemOrder {
        private String name;
        private long id;
        private int count;
        private double price;

        ItemOrder(String name, long id, int count, double price) {
            this.name = name;
            this.id = id;
            this.count = count;
            this.price = price;
        }

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

    /**
     * Represents the shopping cart itself that is received on
     * the /process-order call to create the cart
     */
    static class ItemOrderArray {
        private ItemOrder[] items;
        public ItemOrder[] getItems() {
            return items;
        }
    }

    /**
     * Represents the json object to return from the /process-order
     * call. Contains the public stripe key to create the token,
     * client secret to confirm stripe payment, cart id, and total payment
     * for this transaction.
     */
    static class CreatePaymentResponse {
        private String publishableKey;
        private String clientSecret;
        private int cartId;
        private long totalPayment;

        public CreatePaymentResponse(String publishableKey, String clientSecret, int cartId, long totalPayment) {
            this.publishableKey = publishableKey;
            this.clientSecret = clientSecret;
            this.cartId = cartId;
            this.totalPayment = totalPayment;
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
        public int getCartId() {
            return cartId;
        }
        public void setCartId(int cartId) {
            this.cartId = cartId;
        }
        public long getTotalPayment() {
            return totalPayment;
        }
        public void setTotalPayment(long totalPayment) {
            this.totalPayment = totalPayment;
        }
    }

    /**
     * Helper method to get the user id of the current user
     * or return -1 if there is no user logged in.
     * @return long uid of the user logged in
     */
    private long getUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Object myUser = (auth != null) ? auth.getPrincipal() :  null;

        long uid = -1;
        if (myUser instanceof User) {
            User user = (User) myUser;
            uid = user.getUser_id();
        }
        return uid;
    }

    /**
     * Calculates the total amount of the order by calling the createCartItems
     * stored proc which allows for insertion into the shopping cart table.
     * @param items ItemOrder[] to convert into comma delimited string of id and count
     * @return Object[] of cart id and calculated total amount
     */
    private Object[] calculateOrderAmount(ItemOrder[] items) {

        long uid = getUserId();

        int itemCount = items.length;
        List<String> il = new ArrayList<String>(itemCount);
        List<String> ic = new ArrayList<String>(itemCount);

        for (int i = 0; i < itemCount; i++) {
            il.add(String.valueOf(items[i].getId()));
            ic.add(String.valueOf(items[i].getCount()));
        }
        String il_str = String.join(",", (List) il) + ",";
        String ic_str = String.join(",", (List) ic) + ",";

        SimpleJdbcCall simpleJdbcCall = new SimpleJdbcCall(jdbcTemplate)
                .withProcedureName("createCartItems")
                .declareParameters(
                        new SqlParameter("uid_in", OracleTypes.INTEGER),
                        new SqlParameter("il_in", OracleTypes.VARCHAR),
                        new SqlParameter("ic_in", OracleTypes.VARCHAR),
                        new SqlOutParameter("cartid_out", OracleTypes.INTEGER),
                        new SqlOutParameter("total_out", OracleTypes.DECIMAL));

        Map<String, Object> inParamMap = new HashMap<String, Object>();
        inParamMap.put("uid_in", uid);
        inParamMap.put("il_in", il_str);
        inParamMap.put("ic_in", ic_str);
        SqlParameterSource in = new MapSqlParameterSource(inParamMap);


        Map<String, Object> rs = simpleJdbcCall.execute(in);

        return new Object[] {rs.get("cartid_out"), rs.get("total_out")};
    }

    /**
     * Receives /process-order which creates the shopping cart in the database,
     * contacts stripe to create payment intent, and returns cart amount and
     * the client secret allowing for payment.
     * @param postBody
     * @return
     * @throws StripeException
     */
    @PostMapping(value = "/process-order", produces = "application/json")
    @ResponseBody
    public CreatePaymentResponse secret(@RequestBody ItemOrderArray postBody) throws StripeException {
        String private_key = System.getenv("STRIPE_SECRET_KEY");
        String public_key = System.getenv("STRIPE_PUBLISHABLE_KEY");
        Stripe.apiKey = private_key;

        Object[] ret = calculateOrderAmount(postBody.getItems());
        long total = ((BigDecimal) ret[1]).longValue() * 100;
        int cart_id = (int) ret[0];

        PaymentIntentCreateParams createParams = new PaymentIntentCreateParams.Builder()
                .setCurrency("usd")
                .setAmount(new Long(total))
                .build();

        PaymentIntent intent = PaymentIntent.create(createParams);

        CreatePaymentResponse paymentResponse =
                new CreatePaymentResponse(public_key, intent.getClientSecret(), cart_id,total/100);
        return paymentResponse;
    }

    /**
     * Represent the json sent to /complete-order containing
     * cart total amount, cart id, and payment intent id.
     */
    static class PaymentOrder {
        private double cart_total;
        private int cart_id;
        private String payment_intent;

        PaymentOrder(double cartTotal, int cart_id, String payment_intent) {
            this.cart_total = cartTotal;
            this.cart_id = cart_id;
            this.payment_intent = payment_intent;
        }
        public int getCart_id() {
            return cart_id;
        }
        public double getCart_total() {
            return cart_total;
        }
        public String getPayment_intent() {
            return payment_intent;
        }
    }

    /**
     * Receives the /complete order call on successful payment
     * to insert an order in the database.
     * If it is a user checkout, then pass an id to the query,
     * if not pass in null and infer the guest user from the shopping cart.
     * @param postBody
     */
    @PostMapping(value = "/complete-order", produces = "application/json")
    @ResponseBody
    public void secret(@RequestBody PaymentOrder postBody) {
        long uid = getUserId();
        if (uid != -1) {
            String query = "INSERT INTO ORDERS (user_id, cart_id, final_order_total, payment_intent) VALUES (?, ?, ?, ?)";
            jdbcTemplate.update(
                    query,
                    uid, postBody.getCart_id(), postBody.getCart_total(), postBody.getPayment_intent());
        } else {
            String query = "INSERT INTO ORDERS (cart_id, final_order_total, payment_intent) VALUES (?, ?, ?)";
            jdbcTemplate.update(
                    query,
                    postBody.getCart_id(), postBody.getCart_total(), postBody.getPayment_intent());
        }

    }

    @GetMapping(value = "/history", produces = "application/json")
    @ResponseBody
    public List<Order> orders() {

        List<Order> orderList = null;
        long uid = getUserId();

        if (uid != -1) {
            String query = "SELECT * from Orders WHERE user_id = ?";
            orderList = jdbcTemplate.query(query, new OrderRowMapper(), uid);
        }
        return orderList;
    }

}
