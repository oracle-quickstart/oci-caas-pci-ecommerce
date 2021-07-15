package com.oci.caas.pciecommerce.rest;

import org.apache.maven.model.Model;
import org.apache.maven.model.io.xpp3.MavenXpp3Reader;
import org.codehaus.plexus.util.xml.pull.XmlPullParserException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;

@Controller
public class AboutPageRestController {

    @RequestMapping(value = "version", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public VersionResponse getVersion() throws IOException, XmlPullParserException{
        MavenXpp3Reader reader = new MavenXpp3Reader();
        Model model;
        if (new File("pom.xml").exists()) {
            model = reader.read(new FileReader("pom.xml"));
        } else if (new File("/opt/tomcat_webapp/webapps/ROOT/META-INF/maven/com.oci.caas/pci-ecommerce/pom.xml").exists()) {
            model = reader.read(new FileReader("/opt/tomcat_webapp/webapps/ROOT/META-INF/maven/com.oci.caas/pci-ecommerce/pom.xml" ));
        }
        else{
            model = reader.read(
                    new InputStreamReader(
                            AboutPageRestController.class.getResourceAsStream(
                                    "/META-INF/maven/pom.xml"
                            )
                    )
            );
        }
        return new VersionResponse(model.getVersion());
    }

    static class VersionResponse {
        private String version;

        VersionResponse(String version) {
            this.version = version;
        }

        public String getVersion() { return version; }
    }
}
