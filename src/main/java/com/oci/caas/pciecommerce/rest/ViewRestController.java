package com.oci.caas.pciecommerce.rest;

import com.oci.caas.pciecommerce.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

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
}
