package com.oci.caas.pciecommerce.model;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.xml.ws.RespectBinding;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class User implements UserDetails {
    private long user_id;
    private String email;
    private String password;
    private String street_addr1;
    private String street_addr2;
    private String city;
    private String state;
    private String zipcode;
    private String user_role;

    public User(long user_id, String email, String password, String user_role) {
        this.user_id = user_id;
        this.email = email;
        this.password = password;
        this.user_role = user_role;
    }

    public User() {

    }

    public static RespectBinding builder() {
        return null;
    }

    public long getUser_id() {
        return user_id;
    }

    public void setUser_id(long user_id) {
        this.user_id = user_id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUser_role() {
        return user_role;
    }

    public void setUser_role(String user_role) {
        this.user_role = user_role;
    }

    @Override
    public String toString() {
        return String.format(
                "User[id=%d, email='%s', role='%s']",
                user_id, email, user_role);
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        final List<GrantedAuthority> authorities = Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER"));
        return authorities;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

}


