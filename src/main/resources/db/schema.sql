
-- CREATE USER ECOM IDENTIFIED BY password;
-- GRANT CREATE SESSION TO ECOM;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ECOM.STORE_USER TO ECOM;

CREATE TABLE ECOM.STORE_USER (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
    email VARCHAR2(100) NOT NULL,
    password VARCHAR2(300) NOT NULL,
    street_addr1 VARCHAR2(100),
    street_addr2 VARCHAR2(100),
    city VARCHAR2(100),
    state VARCHAR2(100),
    zipcode VARCHAR2(100),
    PRIMARY KEY (user_id)
);
CREATE TABLE ECOM.SHOPPING_CART (
    cart_id INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
    user_id INTEGER NOT NULL,
    date_completed DATE,
    curr_order_total DECIMAL DEFAULT '0.0',
    PRIMARY KEY (cart_id),
    FOREIGN KEY (user_id) REFERENCES ECOM.STORE_USER(user_id)
);
CREATE TABLE ECOM.ITEM (
    item_id INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
    unit_price DECIMAL NOT NULL,
    stock INTEGER NOT NULL,
    brand_name VARCHAR2(100),
    vendor_name VARCHAR2(100),
    PRIMARY KEY (item_id)
);
CREATE TABLE ECOM.CATEGORY(
    category_id INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
    category_name VARCHAR2(100),
    PRIMARY KEY (category_id)
);
CREATE TABLE ECOM.CART_ITEMS (
    item_id INTEGER NOT NULL,
    cart_id INTEGER NOT NULL,
    quantity INTEGER DEFAULT '1',
    FOREIGN KEY (item_id) REFERENCES ECOM.ITEM(item_id),
    FOREIGN KEY (cart_id) REFERENCES ECOM.SHOPPING_CART(cart_id)
);
CREATE TABLE ECOM.ITEM_CATEGORY (
    item_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    FOREIGN KEY (item_id) REFERENCES ECOM.ITEM(item_id),
    FOREIGN KEY (category_id) REFERENCES ECOM.CATEGORY(category_id),
    PRIMARY KEY(item_id, category_id)
);
CREATE TABLE ECOM.ORDERS (
    order_id INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
    user_id INTEGER NOT NULL,
    cart_id INTEGER NOT NULL,
    final_order_total DECIMAL DEFAULT '0.0',
    ship_date DATE,
    tax DECIMAL DEFAULT '0.0',
    FOREIGN KEY (cart_id) REFERENCES ECOM.SHOPPING_CART(cart_id),
    FOREIGN KEY (user_id) REFERENCES ECOM.STORE_USER(user_id),
    PRIMARY KEY (order_id)
);

-- ALTER USER ADMIN QUOTA UNLIMITED ON DATA;
-- ALTER USER ECOM QUOTA UNLIMITED ON DATA;
INSERT INTO ECOM.STORE_USER (email, password) VALUES ('test@gmail.com', 'test');
INSERT INTO ECOM.STORE_USER (email, password) VALUES ('test2@gmail.com', 'test2');
SELECT * FROM ECOM.STORE_USER;
