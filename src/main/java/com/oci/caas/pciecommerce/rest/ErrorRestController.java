package com.oci.caas.pciecommerce.rest;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

/**
 * Handler provides error handling functionality and maps them to page.
 * Spring uses ErrorMvcAutoConfiguration which by default creates a
 * global error controller.
 */
@Controller
public class ErrorRestController implements ErrorController {

    
    @GetMapping("/custom/error")
	public String getCustomError(@RequestHeader(name = "code") String errorCode) {
		if ("400".equals(errorCode)) {
			return "400";
		} else if ("404".equals(errorCode)) {
			return "404";
		}

		return "error";
	}

	@GetMapping(value = "/custom/errors")
	public String handleError(HttpServletRequest request) {

		Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);

		if (status != null) {

			Integer statusCode = Integer.valueOf(status.toString());

			if (statusCode == HttpStatus.NOT_FOUND.value()) {
				return "404";
			} else if (statusCode == HttpStatus.INTERNAL_SERVER_ERROR.value()) {
				return "500";
			}
		}
		return "error";
	}
    
    @Override
    public String getErrorPath() {
        return null;
    }

}
