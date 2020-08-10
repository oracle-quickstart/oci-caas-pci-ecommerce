
-- CREATE USER ECOM IDENTIFIED BY password;

CREATE TABLE ECOM.STORE_USER (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
    email VARCHAR2(100) NOT NULL,
    password VARCHAR2(300) NOT NULL,
    street_addr1 VARCHAR2(100),
    street_addr2 VARCHAR2(100),
    firstname VARCHAR2(100),
    lastname VARCHAR2(100),
    city VARCHAR2(100),
    state VARCHAR2(100),
    zipcode VARCHAR2(100),
    PRIMARY KEY (user_id)
);
CREATE TABLE ECOM.SHOPPING_CART (
    cart_id INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
    user_id INTEGER NOT NULL,
    date_created DATE,
    date_completed DATE,
    curr_order_total DECIMAL DEFAULT '0.0',
    PRIMARY KEY (cart_id),
    FOREIGN KEY (user_id) REFERENCES ECOM.STORE_USER(user_id)
);
CREATE TABLE ECOM.ITEM (
    item_id INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
    name VARCHAR2(100),
    description VARCHAR2(300),
    unit_price DECIMAL NOT NULL,
    stock INTEGER NOT NULL,
    brand_name VARCHAR2(100),
    vendor_name VARCHAR2(100),
    main_category INTEGER,
    PRIMARY KEY (item_id),
    FOREIGN KEY (main_category)
);
-- change so category to category relation is shown for nesting
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

-- GRANT CREATE SESSION TO ECOM;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON ECOM.STORE_USER TO ECOM;
-- GRANT CREATE TYPE TO ECOM;
-- GRANT DROP ANY TYPE TO ECOM;
-- GRANT EXECUTE ANY TYPE TO ECOM;
-- ALTER USER ADMIN QUOTA UNLIMITED ON DATA;
-- ALTER USER ECOM QUOTA UNLIMITED ON DATA;
INSERT INTO ECOM.STORE_USER (email, password) VALUES ('test@gmail.com', 'test');
INSERT INTO ECOM.STORE_USER (email, password) VALUES ('test2@gmail.com', 'test2');
SELECT * FROM ECOM.STORE_USER;
INSERT INTO ECOM.ITEM (name, stock, unit_price) VALUES ('prod1', 100, 10.00);
INSERT INTO ECOM.ITEM (name, stock, unit_price) VALUES ('prod2', 100, 15.00);


CREATE OR REPLACE TYPE ItemIds AS VARRAY(200) OF INTEGER;
/
CREATE OR REPLACE TYPE ItemCounts AS VARRAY(200) OF INTEGER;
/


SET SERVEROUTPUT ON;
DECLARE
    uid INTEGER     := -1;
    il ItemIds     := ItemIds(23, 24);
    ic ItemCounts    := ItemCounts(12, 8);
    cid INTEGER;
    tout DECIMAL;

BEGIN
    createCart(uid, il, ic, cid, tout);
    dbms_output.put_line('cart id: ' || cid);
    dbms_output.put_line('cart total amount: ' || tout);

END;
/

SELECT
    ECOM.cart_items.ITEM_ID ITEM_ID,
    ECOM.cart_items.CART_ID CART_ID,
    ECOM.cart_items.QUANTITY QUANTITY,
    ECOM.shopping_cart.USER_ID USER_ID,
    ECOM.shopping_cart.DATE_COMPLETED DATE_COMPLETED,
    ECOM.shopping_cart.CURR_ORDER_TOTAL CURR_ORDER_TOTAL,
    ECOM.shopping_cart.DATE_CREATED DATE_CREATED
FROM
    ECOM.cart_items
INNER JOIN ECOM.shopping_cart ON
    ECOM.cart_items.cart_id = ECOM.shopping_cart.cart_id
ORDER BY
    ECOM.shopping_cart.cart_id DESC;

CREATE OR REPLACE PROCEDURE ECOM.createCart (uid_in IN INTEGER DEFAULT -1,
                                        il_in IN ECOM.ItemIds DEFAULT NULL,
                                        ic_in IN ECOM.ItemCounts DEFAULT NULL,
                                        cartid_out OUT INTEGER,
                                        total_out OUT DECIMAL) IS
BEGIN
    IF uid_in = -1 THEN
        DECLARE anon_uid INTEGER;
        BEGIN
            INSERT INTO ECOM.STORE_USER (email, password, user_role) VALUES ('anon', 'anon', 'ROLE_ANONYMOUS') RETURNING user_id INTO anon_uid;
            INSERT INTO ECOM.shopping_cart (user_id, date_created) VALUES (anon_uid, CURRENT_DATE) RETURNING cart_id INTO cartid_out;
        END;

    ELSE
        INSERT INTO ECOM.shopping_cart (user_id, date_created) VALUES (uid_in, CURRENT_DATE) RETURNING cart_id INTO cartid_out;
    END IF;

    total_out := 0;
    FOR i IN 1..il_in.count LOOP
        INSERT INTO ECOM.cart_items (cart_id, item_id, quantity) VALUES (cartid_out, il_in(i), ic_in(i));

        DECLARE item_price DECIMAL;
        BEGIN
            SELECT unit_price INTO item_price FROM ECOM.item WHERE item_id = il_in(i);
            total_out := total_out + item_price * ic_in(i);
        END;
    END LOOP;

    UPDATE ECOM.shopping_cart SET curr_order_total = total_out WHERE cart_id = cartid_out;
END;
/