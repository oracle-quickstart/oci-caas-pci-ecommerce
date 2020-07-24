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


@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    private final DatabaseUserDetailsService databaseUserDetailsService;

    public WebSecurityConfig(DatabaseUserDetailsService databaseUserDetailsService) {
        this.databaseUserDetailsService = databaseUserDetailsService;
    }

    @Bean
    public AuthenticationProvider daoAuthenticationProvider() {
        DaoAuthenticationProvider provider =
                new DaoAuthenticationProvider();
        provider.setPasswordEncoder(passwordEncoder());
        provider.setUserDetailsService(this.databaseUserDetailsService);
        return provider;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception{
        http
            .authorizeRequests()
                .antMatchers("/").permitAll()
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

                .antMatchers("/checkout").hasRole("USER")
                .antMatchers("/process-order").hasRole("USER")


                .anyRequest().authenticated()
                .and()

            .formLogin()
                .loginPage("/login").permitAll()
                .loginProcessingUrl("/authenticate").permitAll()
//                .defaultSuccessUrl("/checkout")
                .failureUrl("/login?error=true").permitAll()
                .and()

            .logout()
                .permitAll()
                .logoutUrl("/logout")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .and()

            .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.ALWAYS);
    }

    @Autowired
    public void configAuthentication(AuthenticationManagerBuilder auth) throws Exception {
        auth
            .authenticationProvider(daoAuthenticationProvider());
    }

}