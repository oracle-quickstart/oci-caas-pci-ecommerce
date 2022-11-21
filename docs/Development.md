# PCI Cat Shop

## Getting Started
### Prerequisites

- Maven
- Java
- Intellij
  - Follow OCI on boarding
- Stripe API credentials
  - Create stripe [account](https://dashboard.stripe.com/test/dashboard) and **note private and public api keys**
- OCI ATP credentials

### Database setup
- Spin up oracle ATP database
  - use oci-caas-client and oci-caas-pci terraform scripts to create the database
  - database username is admin and password is output in the terminal
- In the OCI console navigate to the ATP database and download the wallet
- Unzip the wallet, update tnsnames.ora and add new entry for SSH tunnel connection
    ```text
    atpdb12d92_tunnel = (description= (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1522)(host=localhost))(connect_data=(service_name=f4dxon4zoel2z2z_atpdb12d92_medium.atp.oraclecloud.com))(security=(ssl_server_cert_dn="CN=adwc.uscom-east-1.oraclecloud.com,OU=Oracle BMCS US,O=Oracle Corporation,L=Redwood City,ST=California,C=US")))
    ```
  - Note that the port and host are updated to connect to your SSH tunnel. The entry is named {databasename}_connectionname.
  - ***Adding this entry allows for connnections (tomcat or sqldeveloper) to db while using an ssh tunnel. It must be running to connect.***
- Create the ssh tunnel using the command
    ```bash
    # ssh -L 127.0.0.1:1522:{db_private_ip}:1522 opc@{bastion_public_ip}
    ssh -L 127.0.0.1:1522:10.1.5.2:1522 opc@129.146.50.19
    ```
- Setting up the database schema
  - Download [SQLDeveloper](https://www.oracle.com/database/technologies/appdev/sqldeveloper-landing.html)
  - Create a new connection and input the connection name, admin username, and password. 
  - For connection type, enter cloud wallet and select the downloaded cloud wallet
  - Assuming the connection was created, open the `atp_schema.sql` file located at `src/main/resources/db/`
  - Change line 4 to a secure password and ***take note of it as ECOM user password***
    ```sql
    CREATE USER ECOM IDENTIFIED BY password;
    ```
  - Run the schema. It only adds item and category data.


### Installation
The project repo is here: https://github.com/oracle-quickstart/oci-caas-pci-ecommerce
- `git clone https://github.com/oracle-quickstart/oci-caas-pci-ecommerce`
- Change the credentials in `.env.example` and copy or rename it to .env
    ```bash
    # stripe
    STRIPE_PUBLISHABLE_KEY=pk_test_stripe_pub_key
    STRIPE_SECRET_KEY=sk_test_secret_key
    
    # db
    ORACLE_DB_NAME=db_name_high
    ORACLE_DB_WALLET=/Users/user/path/to/unzipwallet
    ORACLE_DB_USER=schema_name
    ORACLE_DB_PASS='schema_pass'
    ```
    - note: the path to the wallet is the unzipped wallet with the tunnel entry
- Create the ssh tunnel for db connection
- Run locally for development using 
    ```bash
    . run.sh
    ```

### Note
- Maven can not download dependencies on VPN
- In Intellij, you must sync the Maven dependencies or it generate errors. The notification to sync shows up when it detects an import is needed or it can be triggered by modifying the pom (@TODO find out how to mannually trigger the sync/import)
- Tomcat and database connection ***do not*** work with VPN on
- Live reload from dev-tools does not seem to work consistently on static files
- Application has logging level and debug mode set in `application.properties


### Deployment
> Moving from development using embedded tomcat to creating a war deployable on an external server
#### Code
- Verify main method in `PciEcommerceApplication.java` runs as servlet on tomcat (not embedded). If main doesn't look like this comment out entire main class and replace with this block. Import classes as needed.
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
- clean and build new war in the `/target` directory using 
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
