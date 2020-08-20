package com.oci.caas.pciecommerce.service;

import com.oci.caas.pciecommerce.model.User;
import com.oci.caas.pciecommerce.model.UserRowMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Service required for Spring to manage UserDetails
 */
@Service
public class DatabaseUserDetailsService implements UserDetailsService {

    @Autowired
    JdbcTemplate jdbcTemplate;

    public DatabaseUserDetailsService() {
        super();
    }

    /**
     * Only required method for UserDetailsService to find users by their unique username.
     * My usernames are not unique so returning the first user name is the
     * temporary workaround.
     * @param username
     * @return
     * @throws UsernameNotFoundException
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        String query =
                "SELECT user_id, email, password, user_role FROM STORE_USER WHERE email = ? AND user_role = 'ROLE_USER'";
        List<User> personList = jdbcTemplate.query(query, new Object[] { username }, new UserRowMapper());
        /*for (User u : personList) {
            System.out.println(u);
        }*/

        if (personList.size() == 0) {
            throw new UsernameNotFoundException("User not found.");
        }
        return personList.get(0);
    }
}

