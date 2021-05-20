package com.oci.caas.pciecommerce.rest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Handler that serves views and maps endpoints to pages.
 * Each string returned corresponds to an html page or template.
 * @TODO consider using view resolver instead of controller
 *
 */
@Controller
public class ViewRestController {

    @GetMapping("/checkout")
    public String checkout() {
        return "checkout";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/registration")
    public String registration() {
        return "register";
    }

    @GetMapping("/payment")
    public String payment() {
        return "payment";
    }

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping("/about")
    public String about() {
        return "about";
    }

    @GetMapping("/landing")
    public String landing() {
        return "index";
    }

    @GetMapping("/thankyou")
    public String success() {
        return "success";
    }

    @GetMapping("/purchaseHistory")
    public String purchaseHistory() {
        return "purchaseHistory";
    }
}
