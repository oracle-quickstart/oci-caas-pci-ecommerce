package com.oci.caas.pciecommerce.rest;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

public class ErrorRestController {//implements ErrorController {

//    @RequestMapping("/error")
//    public String renderErrorPage(HttpServletRequest httpRequest, Model model) {
//        String errorMsg = "";
//        int httpErrorCode = (int) httpRequest.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
//
//        switch (httpErrorCode) {
//            case 400: {
//                errorMsg = "Http Error Code: 400. Bad Request";
//                break;
//            }
//            case 401: {
//                errorMsg = "Http Error Code: 401. Unauthorized";
//                break;
//            }
//            case 403: {
//                errorMsg = "Http Error Code: 403. Forbidden";
//                break;
//            }
//            case 404: {
//                errorMsg = "Http Error Code: 404. Resource not found";
//                break;
//            }
//            case 500: {
//                errorMsg = "Http Error Code: 500. Internal Server Error";
//                break;
//            }
//            default: {
//                errorMsg = "Http Error Code: " + httpErrorCode;
//                break;
//            }
//        }
//        model.addAttribute("errorMsg", errorMsg);
//        return "error";
//    }
//
//    @Override
//    public String getErrorPath() {
//        return "/error";
//    }
}
