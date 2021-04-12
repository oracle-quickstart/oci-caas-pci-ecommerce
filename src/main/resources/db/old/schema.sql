
--------------------------------------------------------
--  Queries for development of PCI DB
--------------------------------------------------------

/**
 * Creating app user
 */
CREATE USER ECOM IDENTIFIED BY "password";
GRANT CREATE SESSION TO ECOM;
GRANT CREATE TYPE TO ECOM;
GRANT DROP ANY TYPE TO ECOM;
GRANT EXECUTE ANY TYPE TO ECOM;
ALTER USER ADMIN QUOTA UNLIMITED ON DATA;
ALTER USER ECOM QUOTA UNLIMITED ON DATA;

/**
 * Create the tables initially. 
 * Tables likely changed from this structure
 */
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
    user_id INTEGER,
    cart_id INTEGER NOT NULL,
    final_order_total DECIMAL DEFAULT '0.0',
    ship_date DATE,
    tax DECIMAL DEFAULT '0.0',
    payment_intent VARCHAR2(100),
    FOREIGN KEY (cart_id) REFERENCES ECOM.SHOPPING_CART(cart_id),
    FOREIGN KEY (user_id) REFERENCES ECOM.STORE_USER(user_id),
    PRIMARY KEY (order_id)
);


/**
 * USEFUL QUERIES
 */
select i.item_id, i.name, i.unit_price, i.stock, i.main_category, c.category_name 
    from item i, category c
where item.main_category = category.category_id
order by category.category_name;

select * from shopping_cart;
select * from orders;
select * from cart_items;

select * from item_category;
select * from category;
select * from item;

select * from store_user;

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


/**
 * INSERTING CATEGORIES AND ITEMS
 */

INSERT INTO ECOM.STORE_USER (email, password) VALUES ('test@gmail.com', 'test');
INSERT INTO ECOM.STORE_USER (email, password) VALUES ('test2@gmail.com', 'test2');

SELECT * FROM ECOM.STORE_USER;
INSERT INTO ECOM.ITEM (name, stock, unit_price) VALUES ('prod1', 100, 10.00);
INSERT INTO ECOM.ITEM (name, stock, unit_price) VALUES ('prod2', 100, 15.00);

select * from category;
INSERT INTO category (category_name) VALUES ('Auto Feeders');
INSERT INTO category (category_name) VALUES ('Bowls');
INSERT INTO category (category_name) VALUES ('Placemats');
INSERT INTO category (category_name) VALUES ('Storage');
INSERT INTO category (category_name) VALUES ('Brushes');
INSERT INTO category (category_name) VALUES ('Grooming Tools');
INSERT INTO category (category_name) VALUES ('Shampoos');
INSERT INTO category (category_name) VALUES ('Cleaning Supplies');


select * from item;

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Chicken and Pomegranate Mu Cat Food', 100, 38.95, 25,
'Your cats deserve the best scientifically proven food to maintain a healthy weight. Natural and Delicious Grain Free Chicken and Pomegranate Recipe Dry Cat Food does not contain any cereal or grains of any kind and is completely replaced with the highest quality protein. ');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Cat and Kitten BlueHill MagiK', 100, 49.95, 25,
'Cat and Kitten recipe is a grain-free, region-inspired formula that your cat will thrive on. An excellent choice for cats of all breed and ages, this biologically appropriate recipe contains an unmatched variety of fresh regional ingredients.');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Wet Canned Mu Dry Food', 100, 49.75, 26,
'Wellness Complete Health Natural Grain Free Chicken Recipe Canned Cat Food is made with 100% Human Grade Ingredients and uses delicious fruits and vegetables which contain vitamins and antioxidants to help maintain your cats healthy immune system. ');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Green Pea Formula Mu Cat Food', 100, 39.99, 26,
'Designed with a limited number of premium protein and carbohydrate sources, this Grain-free cat food is an excellent choice when seeking alternative ingredients for your cat. Natural Balance L.I.D. Limited Ingredient Diets Duck and Green Pea Formula Canned Cat Food is designed to support healthy digestion and to maintain skin and coat health all while providing complete, balanced nutrition for all life stages!');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Go Cat Variety Pouches Pack', 100, 12.99, 27,
'Lets show our cats that they are truly our best friends, with the new Weruva Grain-Free BFF OMG Pouches Variety Pack. Made with white breast chicken, real, sustainably caught tuna, fresh wild caught salmon, and other real, deboned meats, Weruva has created the perfect meal for our furry, purring best friends.');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Love Me Variety Pack Green', 100, 15.99, 27,
'Full of duck, tuna, and white breast, skinless, and boneless chicken, this wholesome food is full of protein and free of any grains, GMOs, MSG, and carrageenan for a balanced meal in each can. Weruva Cats In the Kitchen Love Me Tender Pouches Wet Cat Food will fill your cat with love, tenderly with every meal.');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Original MuMate Bowl', 100, 43.95, 41,
'Original Pet Fountain with Bonus Reservoir provides 50 oz of fresh, filtered water to your pet, with an additional Bonus 50 Ounce Reservoir. A patented free-falling stream of water entices your pet to drink more and continually aerates the water with healthful oxygen.');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Drinkwell BrandX Feeder', 100, 79.95, 41,
'The Pagoda fountain continuously recirculates 70 ounces of fresh, filtered water. Best of all, the stylish ceramic design is easy to clean and looks great in your home. The upper and lower dishes provide two drinking areas for pets, and the patented dual free-falling streams aerate the water for freshness, which encourages your pet to drink more.');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Crock Small Coastal FishBowl', 100, 4.75, 42,
'Standard crock small animal dish is uses a heavy weight design that eliminates movement and spillage.');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Mu Fusion Bowl', 100, 5.99, 42,
'Functional and beautiful, Bella Bowls are truly the perfect pet dish. Loving Pets brings new life to veterinarian-recommended stainless steel dog bowls and pet feeding dishes by combining a stainless interior with an attractive poly-resin exterior. A removable rubber base prevents spills, eliminates noise, and makes Bella Bowls fully dishwasher safe.');


INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('SO Dry Cat Food', 100, 68.99, 27,
'Functional and beautiful, Bella Bowls are truly the perfect pet dish. Loving Pets brings new life to veterinarian-recommended stainless steel dog bowls and pet feeding dishes by combining a stainless interior with an attractive poly-resin exterior. A removable rubber base prevents spills, eliminates noise, and makes Bella Bowls fully dishwasher safe.');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Care with Chicken BlueHill MagiK', 100, 68.99, 26,
'A healthy bladder starts with the right balance of vital nutrients. Excess minerals can encourage the formation of crystals in the urine, which may lead to the creation of bladder stones. They can cause discomfort and lead to more serious problems that require the care of a veterinarian.');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Mu DeoSpray Deodorizer', 100, 7.99, 61,
'With Choco Spring scents lingering in the air, your cats time in the bathroom doesnt have to be so smelly anymore! This deodorizer perfumes the air and helps make the litter last longer so you and your cat can enjoy a breath of sweetly-scented air.');

INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Mu O-DeoSpray Deodorizer', 100, 4.99, 61,
'Add an extra boost of freshness to your litter box. ARM AND HAMMER baking soda destroys odors instantly in all types of litter - so your box stays first-day fresh longer. ');


INSERT INTO ECOM.ITEM (name, stock, unit_price, main_category, description) VALUES ('Mu X-DeoSpray Deodorizer', 100, 39.99, 61,
'Change the way you think about cleaning your cats litter box with the Purina Tidy Cats BREEZE With Ammonia Blocker Litter System starter kit. This system features powerful odor control to keep your house smelling fresh and clean, and the specially designed, cat-friendly litter pellets minimize your pets from tracking litter throughout your home.');


CREATE OR REPLACE TYPE ItemIds AS VARRAY(200) OF INTEGER;
/
CREATE OR REPLACE TYPE ItemCounts AS VARRAY(200) OF INTEGER;
/

/**
 * Testing original createCart
 */
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

/**
 * ORIGINAL CREATE CART ITEMS THAT USES VARRARRAY.
 * FORCED TO CHANGE IT BECUASE CALLING IT FROM JAVA RAISED ISSUE 
 * CONVERTING INTERNAL JAVA ARRAY TYPE TO SQL TYPE
 */
CREATE OR REPLACE PROCEDURE ECOM.createCart (uid_in IN INTEGER DEFAULT -1,
                                        il_in IN ECOM.ItemIds DEFAULT NULL,
                                        ic_in IN ECOM.ItemCounts DEFAULT NULL,
                                        cartid_out OUT INTEGER,
                                        total_out OUT DECIMAL) IS
BEGIN
    IF uid_in = -1 THEN
        DECLARE anon_uid INTEGER;
        BEGIN
            INSERT INTO ECOM.STORE_USER (email, password, user_role) 
                VALUES ('anon', 'anon', 'ROLE_ANONYMOUS') 
                RETURNING user_id INTO anon_uid;
            INSERT INTO ECOM.shopping_cart (user_id, date_created) 
                VALUES (anon_uid, CURRENT_DATE) 
                RETURNING cart_id INTO cartid_out;
        END;

    ELSE
        INSERT INTO ECOM.shopping_cart (user_id, date_created) 
            VALUES (uid_in, CURRENT_DATE) RETURNING cart_id 
            INTO cartid_out;
    END IF;

    total_out := 0;
    FOR i IN 1..il_in.count LOOP
        INSERT INTO ECOM.cart_items (cart_id, item_id, quantity) 
            VALUES (cartid_out, il_in(i), ic_in(i));

        DECLARE item_price DECIMAL;
        BEGIN
            SELECT unit_price INTO item_price 
                FROM ECOM.item 
                WHERE item_id = il_in(i);
            total_out := total_out + item_price * ic_in(i);
        END;
    END LOOP;

    UPDATE ECOM.shopping_cart 
        SET curr_order_total = total_out 
        WHERE cart_id = cartid_out;
END;
/


/*** FIGURING OUT HOW TO USE COMMA DELMITTED STRING INSTEAD OF ARRAY ***/
set SERVEROUTPUT on;
declare
    string_to_parse varchar2(2000) := '23,24';
    l_count number;
    l_value   varchar2(2000);
begin
    string_to_parse := string_to_parse||',';
    l_count := regexp_count(string_to_parse, ',', 1);
    for i in 1 .. l_count loop 
        declare temp varchar2(10);
        begin
            select regexp_substr(string_to_parse,'[^,]+',1,i)
            into temp
            from dual;
            select name into l_value from ECOM.item where item_id=temp;
            dbms_output.put_line('iter: ' || i|| ' val: ' || l_value || temp);

        end;
    end loop;
end;
/


declare
  string_to_parse varchar2(2000) := 'abc,def,ghi,klmno,pqrst';
  l_count number;
  l_value   varchar2(2000);
begin
  string_to_parse := string_to_parse||',';
  l_count := length(string_to_parse) - length(replace(string_to_parse,',',''));
  -- In oracle 11g use regexp_count to determine l_count
  for i in 1 .. l_count loop 
    select regexp_substr(string_to_parse,'[^,]+',1,i)
    into l_value
    from dual;
    dbms_output.put_line('count ' || i || ' ' || l_value);
  end loop;
end;
/

/*** TESTING AND CREATING NEW VERSION OF CREATE CART THAT USES COMMA DELIMITED STRINGS***/
SET SERVEROUTPUT ON;
DECLARE
    uid INTEGER := -1;
    il VARCHAR2(100) := '23, 24,';
    ic VARCHAR2(100) := '12, 8,';
    cid INTEGER;
    tout DECIMAL;

BEGIN
    ECOM.createCartItems(uid, il, ic, cid, tout);
    dbms_output.put_line('cart id: ' || cid);
    dbms_output.put_line('cart total amount: ' || tout);

END;
/


CREATE OR REPLACE PROCEDURE ECOM.createCartItems (uid_in IN INTEGER DEFAULT -1,
                                        il_in IN VARCHAR2,
                                        ic_in IN VARCHAR2,
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
    /*il_in := il_in || ',';
    ic_in := ic_in || ',';*/
    
    DECLARE il_count INTEGER;
    BEGIN
        il_count := regexp_count(il_in, ',', 1);
        FOR i IN 1 .. il_count LOOP
            DECLARE
                temp_il VARCHAR2(100);
                temp_ic VARCHAR2(100);
                item_price DECIMAL;
            BEGIN
                SELECT regexp_substr(il_in, '[^,]+', 1, i) INTO temp_il FROM DUAL;
                SELECT regexp_substr(ic_in, '[^,]+', 1, i) INTO temp_ic FROM DUAL;
                
                INSERT INTO ECOM.cart_items (cart_id, item_id, quantity) VALUES (cartid_out, temp_il, temp_ic);
                
                SELECT unit_price INTO item_price FROM ECOM.item WHERE item_id = temp_il;
                total_out := total_out + item_price * temp_ic;
            END;
        END LOOP;
    END;

    UPDATE ECOM.shopping_cart SET curr_order_total = total_out WHERE cart_id = cartid_out;
END;
/
