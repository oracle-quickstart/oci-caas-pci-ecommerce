package com.oci.caas.pciecommerce.rest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

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

    @GetMapping("/landing")
    public String landing() {
        return "landing";
    }
}
