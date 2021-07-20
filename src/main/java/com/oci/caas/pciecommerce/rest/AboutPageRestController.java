package com.oci.caas.pciecommerce.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;


@Controller
public class AboutPageRestController {
    @Autowired
    BuildProperties buildProperties;
    @RequestMapping(value = "version", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public VersionResponse getVersion() {

        String app_version= buildProperties.getVersion();

        return new VersionResponse(app_version);
    }

    static class VersionResponse {
        private String version;

        VersionResponse(String version) {
            this.version = version;
        }

        public String getVersion() { return version; }
    }
}
