package com.oci.caas.pciecommerce;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * PCI Ecommerce Application
 */

@SpringBootApplication
//public class PciEcommerceApplication {
public class PciEcommerceApplication extends SpringBootServletInitializer {

	public static void main(String[] args) {
		SpringApplication.run(PciEcommerceApplication.class, args);
	}

	/**
	 * Method used for traditional Spring spring war deployment
	 */
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
		return builder.sources(PciEcommerceApplication.class);
	}
}