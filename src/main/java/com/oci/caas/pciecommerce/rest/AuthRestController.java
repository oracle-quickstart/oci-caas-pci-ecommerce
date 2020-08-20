package com.oci.caas.pciecommerce.rest;

import com.oci.caas.pciecommerce.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * Controller that deals with all user or auth functions.
 * Registering requires injected password encoder.
 * @TODO add custom login success and failure handlers
 */
@Controller
public class AuthRestController {

    @Autowired
    JdbcTemplate jdbcTemplate;

    @Autowired
    PasswordEncoder passwordEncoder;

    /**
     * Represents user auth containing minimal information.
     * Used to retrieve info on who is logged in.
     */
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

    /**
     * Represents new user's registration request sent on
     * /register post.
     */
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

    /**
     * Creates new user in db from username and bcrypt hashed password
     * Does not return the user id becuause the insert statement returns nothing
     * @TODO check if username is unique and return error message on failure
     * @param req authRequest
     * @return authResponse
     */
    @PostMapping(value = "/register", produces = "application/json")
    @ResponseBody
    public authResponse register(@RequestBody authRequest req) {
        String encodedPassword  = passwordEncoder.encode(req.getPassword());

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

    /**
     * Gets the current user if there is one logged in, Guest otherwise
     * @return authResponse
     */
    @GetMapping(value = "/currentUser", produces = "application/json")
    @ResponseBody
    public authResponse currentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Object myUser = (auth != null) ? auth.getPrincipal() :  null;

        if (myUser instanceof User) {
            User user = (User) myUser;
            //System.out.println(user.getUsername());
            return new authResponse(user.getUsername(), user.getUser_role(), user.getUser_id());
        }

        return new authResponse("Guest", "ROLE_ANONYMOUS", -1);
    }
}
