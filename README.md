# PCI Cat Shop

PCI-Ecommerce is a PCI compliant website thats part of the Compliance as a Service MVP.

## Getting Started
### Prerequisites

- Maven
- Java
- Intellij
  - *Follow OCI on boarding*
- Stripe API credentials
  - *Create stripe account*
  - ***note private and public api keys***
- OCI ATP credentials
  - *spin up oracle ATP database with admin password and other configuration*
  - *create wallet with password and download*
  - *download SQLDeveloper*
  - *connect using cload wallet and admin credentials*
  - *create database with schema*
  - ***note ECOM user(non admin) credentials***

### Installation
- `git clone`
- Download wallet to secure location
- Change the credentials in `.env.example`
    ```bash
    # stripe
    STRIPE_PUBLISHABLE_KEY=pk_test_stripe_pub_key
    STRIPE_SECRET_KEY=sk_test_secret_key
    
    # db
    ORACLE_DB_NAME=db_name_high
    ORACLE_DB_WALLET=/Users/user/path/to/wallet
    ORACLE_DB_USER=schema_name
    ORACLE_DB_PASS='schema_pass'
    ```
- Run locally for development using 
    ```bash
    . run.sh
    ```

### Note
- Tomcat and database connection ***do not*** work with VPN on
- Live reload from dev-tools doesn't seem to work consistently on static files
- Application has logging level and debug mode set in `application.properties


### Deployment
> Moving from development using embedded tomcat to creating a war deployable on an external server
#### Code
- Verify main to run as servlet on tomcat (not embedded)
    ```java
    @SpringBootApplication
    public class PciEcommerceApplication extends SpringBootServletInitializer {

        public static void main(String[] args) {
            SpringApplication.run(PciEcommerceApplication.class, args);
        }

        @Override
        protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
            return builder.sources(PciEcommerceApplication.class);
        }
    }
    ```
- @TODO REMOVE DEBUG MODE
- @TODO REMOVE DEBUG SETTINGS
- @TODO ADD CUSTOM ERROR PAGE AND REMOVE STACK TRACE

#### Maven
- verify `pom.xml` has following
    `<packaging>war</packaging>`
- war will be named `${artifactId}-${version}`
- update version eg. `<version>0.0.1-SNAPSHOT</version>` using [semantic versioning](semver.org)
- verify spring-boot-starter-web excludes tomcat and that spring-boot-starter-tomcat is included with scope provided
    ```xml
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <exclusions>
            <exclusion>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-tomcat</artifactId>
            </exclusion>
        </exclusions>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-tomcat</artifactId>
        <scope>provided</scope>
    </dependency>
    ```
- > provided means tomcat is included in the runtime environment
- clean and build new war using 
    ```shell
    mvn clean
    mvn package
    ```
- > this should generate the package.war and package.war.original because maven does [repackaging](https://stackoverflow.com/questions/43641664/why-spring-boot-generates-jar-or-war-file-with-original-extension)

#### Tomcat
- configure `server.xml` for different port
    ```xml
    <Connector port="8081" protocol="HTTP/1.1"
            connectionTimeout="20000"
            redirectPort="8443" /> 
    ```
- add to `tomcat-users.xml`
    ```xml
    <role rolename="manager-gui"/>
        <role rolename="manager-script"/>
        <user username="admin" password="password" roles="manager-gui, manager-script"/>
    </tomcat-users>
    ```
- > I added admin user when I was using the managing app on ROOT. May need this to access other admin servlets
- > I tested changing `web.xml` default servlet mapping because it couldn't find static content but that didnt work
- copy the war file to `/<tomcat>/webapps` folder
- rename or delete default `/ROOT/` folder
- rename war file to `ROOT.war`
- in `/<tomcat>` folder run 
    ```shell
    bin/catalina.sh run
    ```
- view app on http://localhost:8081/


#### Deploying Resources
  - maven [snapshot](https://stackoverflow.com/questions/5901378/what-exactly-is-a-maven-snapshot-and-why-do-we-need-it)
  - > Snapshot indicates in development before production release
  - [servlet url](https://stackoverflow.com/questions/20405474/add-context-path-to-spring-boot-application)
  - [servlet api calls](https://stackoverflow.com/questions/46280399/spring-boot-rest-controller-returns-404-when-deployed-on-external-tomcat-9-serve)
  - > I couldnt load css and js (but it could load images) so I thought it was an issue finding static content. I tried changing application.properties and was going to add webmvcconfigure class`
  - [static resources on tomcat](https://stackoverflow.com/questions/41190635/css-and-js-file-not-loading-while-deploying-war-file-on-apache-tomcat)
  - > The endpoint calls were being made to `root/api` instead of `root/servlet/api`. Changing the default servlet worked.
  - [default servlet](https://stackoverflow.com/questions/14223150/mapping-a-specific-servlet-to-be-the-default-servlet-in-tomcat)


### Security
- 

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)