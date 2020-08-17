package com.oci.caas.pciecommerce.rest;

import com.oci.caas.pciecommerce.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthRestController {

    @Autowired
    JdbcTemplate jdbcTemplate;

    @Autowired
    PasswordEncoder passwordEncoder;

    static class authResponse {
        private String username;
        private String user_role;
        private long user_id;

        public authResponse(String username, String user_role, long user_id) {
            this.username = username;
            this.user_role = user_role;
            this.user_id = user_id;
        }
        public String getUsername() {
            return username;
        }
        public String getUser_role() {
            return user_role;
        }
        public long getUser_id() {
            return user_id;
        }
    }

    static class authRequest {
        private String username;
        private String password;
        public authRequest(String username, String password) {
            this.username = username;
            this.password = password;
        }
        public String getUsername() {
            return username;
        }
        public String getPassword() {
            return password;
        }
    }

    @PostMapping(value = "/register", produces = "application/json")
    @ResponseBody
    public authResponse register(@RequestBody authRequest req) {
        String encodedPassword  = passwordEncoder.encode(req.getPassword());
        System.out.println("pwd: " + encodedPassword);

        User user = new User();
        user.setPassword(encodedPassword);
        user.setEmail(req.getUsername());
        user.setUser_role("ROLE_USER");

        String query = "INSERT INTO STORE_USER (email, password, user_role) VALUES (?, ?, ?)";
        jdbcTemplate.update(
                query,
                new Object[]{user.getEmail(), user.getPassword(), user.getUser_role()}
        );
        return new authResponse(user.getUsername(), user.getUser_role(), -1);

    }

    @GetMapping(value = "/currentUser", produces = "application/json")
    @ResponseBody
    public authResponse currentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Object myUser = (auth != null) ? auth.getPrincipal() :  null;

        if (myUser instanceof User) {
            User user = (User) myUser;
            System.out.println(user.getUsername());
            return new authResponse(user.getUsername(), user.getUser_role(), user.getUser_id());
        }

        return new authResponse("Guest", "ROLE_ANONYMOUS", -1);
    }
}
