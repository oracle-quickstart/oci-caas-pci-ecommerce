package com.oci.caas.pciecommerce.config;

import com.oci.caas.pciecommerce.service.DatabaseUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * Configuration managing security through setting UserDetailService,
 * authentication provider, password encoder, and managing endpoints.
 */
@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    private final DatabaseUserDetailsService databaseUserDetailsService;

    public WebSecurityConfig(DatabaseUserDetailsService databaseUserDetailsService) {
        this.databaseUserDetailsService = databaseUserDetailsService;
    }

    @Autowired
    public void configAuthentication(AuthenticationManagerBuilder auth) throws Exception {
        auth
            .authenticationProvider(daoAuthenticationProvider());
    }

    @Bean
    public AuthenticationProvider daoAuthenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setPasswordEncoder(passwordEncoder());
        provider.setUserDetailsService(this.databaseUserDetailsService);
        return provider;
    }

    /**
     * Default BCryptPasswordEncoder has strength of 10 and manages the salt.
     * @return
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * Manage endpoints, session, and cookies
     * @TODO Add custom login and logout success/failure handlers at form login
     * @param http
     * @throws Exception
     */
    @Override
    protected void configure(HttpSecurity http) throws Exception{
        http
            .authorizeRequests()
                .antMatchers("/").permitAll()
                .antMatchers("/about").permitAll()
                .antMatchers("/css/**").permitAll()
                .antMatchers("/js/**").permitAll()
                .antMatchers("/images/**").permitAll()

                .antMatchers("/products").permitAll()
                .antMatchers("/payment").permitAll()
                .antMatchers("/create-payment-intent").permitAll()
                .antMatchers("/registration").permitAll()
                .antMatchers("/register").permitAll()
                .antMatchers("/currentUser").permitAll()
                .antMatchers("/landing").permitAll()
                .antMatchers("/thankyou").permitAll()
                .antMatchers("/checkout").permitAll()
                .antMatchers("/process-order").permitAll()
                .antMatchers("/complete-order").permitAll()
                .antMatchers("/history").permitAll()
                .antMatchers("/purchaseHistory").permitAll()
                .antMatchers("/error").permitAll()
                .antMatchers("/login").permitAll()

                .anyRequest().authenticated()
                .and()

            .formLogin()
                .loginPage("/login.html").permitAll()
                .loginProcessingUrl("/authenticate").permitAll()
                .defaultSuccessUrl("/checkout")
                .failureUrl("/login?error=true").permitAll()
                .and()

            .logout()
                .permitAll()
                .logoutUrl("/logout")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .and()

            .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.ALWAYS)
                .and()

            .headers()
                .contentSecurityPolicy("script-src 'self' https://js.stripe.com; connect-src 'self' https://js.stripe.com; frame-src https://js.stripe.com https://hooks.stripe.com");

    }
}