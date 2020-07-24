package com.oci.caas.pciecommerce.rest;


import com.oci.caas.pciecommerce.model.Item;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import sun.tools.jconsole.JConsole;

@Controller
public class OrderRestController {

    static class CreatePaymentBody {
        private Object[] items;
        private String currency;
        public Object[] getItems() {
            return items;
        }
        public String getCurrency() {
            return currency;
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

    static int calculateOrderAmount(Object[] items) {
        // Replace this constant with a calculation of the order's amount
        // Calculate the order total on the server to prevent
        // users from directly manipulating the amount on the client
        double total = 0;
        for (Object i : items) {
            System.out.println("item: "+ i);
        }
        return 1000;
    }

    @Autowired
    JdbcTemplate jdbcTemplate;


    @PostMapping(value = "/process-order", produces = "application/json")
    @ResponseBody
    public TestRestController.CreatePaymentResponse secret(@RequestBody CreatePaymentBody postBody) throws StripeException {
        String private_key = System.getenv("STRIPE_SECRET_KEY");
        String public_key = System.getenv("STRIPE_PUBLISHABLE_KEY");

        Stripe.apiKey = private_key;

        PaymentIntentCreateParams createParams = new PaymentIntentCreateParams.Builder()
                .setCurrency("usd")
                .setAmount(new Long(calculateOrderAmount(postBody.getItems())))
                .build();

        // Create a PaymentIntent with the order amount and currency
        PaymentIntent intent = PaymentIntent.create(createParams);

        // Send publishable key and PaymentIntent details to client
        TestRestController.CreatePaymentResponse paymentResponse = new TestRestController.CreatePaymentResponse(public_key, intent.getClientSecret());
        return paymentResponse;
    }
}
