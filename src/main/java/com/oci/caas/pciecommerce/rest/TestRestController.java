package com.oci.caas.pciecommerce.rest;

import com.oci.caas.pciecommerce.model.Person;

import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;

/**
 * Handler used for testing of templating (through /greeting)
 * and stripe api (through /payment)
 */
@Controller
public class TestRestController {

    /**
     *
     */
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

    /**
     *
     */
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

    /**
     *
     * @param items
     * @return
     */
    static int calculateOrderAmount(Object[] items) {
        // Replace this constant with a calculation of the order's amount
        // Calculate the order total on the server to prevent
        // users from directly manipulating the amount on the client
        return 1000;
    }

    @Autowired
    JdbcTemplate jdbcTemplate;

    /**
     *
     * @param name
     * @param model
     * @return
     */
    @GetMapping("/greeting")
    public String greeting(@RequestParam(name = "name", required = false, defaultValue = "World") String name, Model model) {
        String query = "Select personid, firstname, lastname from persons";
        ArrayList<Person> personArrayList = new ArrayList<>();
        jdbcTemplate.query(
                query,
                (rs, rowNum) -> new Person(rs.getLong("PERSONID"), rs.getString("FIRSTNAME"), rs.getString("LASTNAME"))
        ).forEach(person -> {
            personArrayList.add(person);
            System.out.println(person.toString());});

        model.addAttribute("name", name);
        model.addAttribute("persons", personArrayList);
        return "greeting";
    }

    /**
     *
     * @param postBody
     * @return
     * @throws StripeException
     */
    @PostMapping(value = "/create-payment-intent", produces = "application/json")
    @ResponseBody
    public CreatePaymentResponse secret(@RequestBody CreatePaymentBody postBody) throws StripeException {
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
        CreatePaymentResponse paymentResponse = new CreatePaymentResponse(public_key, intent.getClientSecret());
        return paymentResponse;
    }

}
