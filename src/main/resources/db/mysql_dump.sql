CREATE DATABASE mysql_cluster;
USE mysql_cluster;
CREATE USER ECOM IDENTIFIED BY "password";
grant all privileges on mysql_cluster.* to 'ECOM'@'%';
GRANT ALL ON CART_ITEMS TO ECOM;
GRANT ALL ON CATEGORY TO ECOM;
GRANT ALL ON ITEM TO ECOM;
GRANT ALL ON ITEM_CATEGORY TO ECOM;
GRANT ALL ON ORDERS TO ECOM;
GRANT ALL ON SHOPPING_CART TO ECOM;
GRANT ALL ON STORE_USER TO ECOM;

CREATE TABLE CART_ITEMS
(
    ITEM_ID INT NOT NULL,
    CART_ID INT NOT NULL,
    QUANTITY INT DEFAULT 1,
    PRIMARY KEY (ITEM_ID, CART_ID)
);

CREATE TABLE CATEGORY
(
    CATEGORY_ID INT NOT NULL AUTO_INCREMENT ,
    CATEGORY_NAME VARCHAR(100),
    PRIMARY KEY (CATEGORY_ID)
);

CREATE TABLE ITEM
(
    ITEM_ID INT NOT NULL AUTO_INCREMENT ,
    UNIT_PRICE DECIMAL(38,0) NOT NULL,
    STOCK INT NOT NULL,
    BRAND_NAME VARCHAR(100),
    VENDOR_NAME VARCHAR(100),
    NAME VARCHAR(100) NOT NULL,
    DESCRIPTION VARCHAR(500),
    MAIN_CATEGORY INT,
    PRIMARY KEY (ITEM_ID),
    CONSTRAINT ITEM_CATEGORY_FK FOREIGN KEY (MAIN_CATEGORY) REFERENCES CATEGORY (CATEGORY_ID)ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE ITEM_CATEGORY
(
    ITEM_ID INT NOT NULL,
    CATEGORY_ID INT NOT NULL,
    PRIMARY KEY (ITEM_ID, CATEGORY_ID)
);

CREATE TABLE ORDERS
(
    ORDER_ID INT NOT NULL AUTO_INCREMENT ,
    USER_ID INT,
    CART_ID INT NOT NULL,
    FINAL_ORDER_TOTAL DECIMAL(38,0) DEFAULT '0.0',
    SHIP_DATE DATETIME,
    TAX DECIMAL(38,0) DEFAULT '0.0',
    PAYMENT_INTENT VARCHAR(100),
    PRIMARY KEY (ORDER_ID)
);

CREATE TABLE SHOPPING_CART
(
    CART_ID INT NOT NULL,
    USER_ID INT  NOT NULL ,
    DATE_COMPLETED DATETIME,
    CURR_ORDER_TOTAL DECIMAL(38,0) DEFAULT '0.0',
    DATE_CREATED DATETIME,
    PRIMARY KEY (CART_ID)
);

CREATE TABLE STORE_USER
(
    USER_ID INT NOT NULL AUTO_INCREMENT ,
    EMAIL VARCHAR(100) NOT NULL,
    PASSWORD VARCHAR(300) NOT NULL,
    STREET_ADDR1 VARCHAR(100),
    STREET_ADDR2 VARCHAR(100),
    CITY VARCHAR(100),
    STATE VARCHAR(100),
    ZIPCODE VARCHAR(100),
    USER_ROLE VARCHAR(50) DEFAULT 'ROLE_USER',
    FIRSTNAME VARCHAR(100),
    LASTNAME VARCHAR(100),
    PRIMARY KEY (USER_ID)
);

CREATE UNIQUE INDEX SYS_C0011836 ON STORE_USER (USER_ID);

CREATE UNIQUE INDEX SYS_C0011839 ON SHOPPING_CART (CART_ID);

CREATE UNIQUE INDEX SYS_C0011844 ON ITEM (ITEM_ID);

CREATE UNIQUE INDEX SYS_C0011846 ON CATEGORY (CATEGORY_ID);

CREATE UNIQUE INDEX SYS_C0011853 ON ITEM_CATEGORY (ITEM_ID, CATEGORY_ID);

CREATE UNIQUE INDEX SYS_C0011859 ON ORDERS (ORDER_ID);

Insert into CATEGORY (CATEGORY_NAME) values
('Dry Food'),
('Wet Food'),
('Food Pouches'),
('Limited Diet'),
('Auto Feeders'),
('Bowls'),
('Placemats'),
('Storage'),
('Brushes'),
('Grooming Tools'),
('Shampoos'),
('Cleaning Supplies');

Insert into ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values
(44,100,null,null,'Original MuMate Bowl','Original Pet Fountain with Bonus Reservoir provides 50 oz of fresh, filtered water to your pet, with an additional Bonus 50 Ounce Reservoir. A patented free-falling stream of water entices your pet to drink more and continually aerates the water with healthful oxygen.',5),
(80,100,null,null,'Drinkwell BrandX Feeder','The Pagoda fountain continuously recirculates 70 ounces of fresh, filtered water. Best of all, the stylish ceramic design is easy to clean and looks great in your home. The upper and lower dishes provide two drinking areas for pets, and the patented dual free-falling streams aerate the water for freshness, which encourages your pet to drink more.',5),
(5,100,null,null,'Crock Small Coastal FishBowl','Standard crock small animal dish is uses a heavy weight design that eliminates movement and spillage.',6),
(6,100,null,null,'Mu Fusion Bowl','Functional and beautiful, Bella Bowls are truly the perfect pet dish. Loving Pets brings new life to veterinarian-recommended stainless steel dog bowls and pet feeding dishes by combining a stainless interior with an attractive poly-resin exterior. A removable rubber base prevents spills, eliminates noise, and makes Bella Bowls fully dishwasher safe.',6),
(39,100,null,null,'Chicken and Pomegranate Mu Cat Food','Your cats deserve the best scientifically proven food to maintain a healthy weight. Natural and Delicious Grain Free Chicken and Pomegranate Recipe Dry Cat Food does not contain any cereal or grains of any kind and is completely replaced with the highest quality protein. ',1),
(50,100,null,null,'Cat and Kitten BlueHill MagiK','Cat and Kitten recipe is a grain-free, region-inspired formula that your cat will thrive on. An excellent choice for cats of all breed and ages, this biologically appropriate recipe contains an unmatched variety of fresh regional ingredients.',1),
(50,100,null,null,'Wet Canned Mu Dry Food','Wellness Complete Health Natural Grain Free Chicken Recipe Canned Cat Food is made with 100% Human Grade Ingredients and uses delicious fruits and vegetables which contain vitamins and antioxidants to help maintain your cats healthy immune system. ',2),
(40,100,null,null,'Green Pea Formula Mu Cat Food','Designed with a limited number of premium protein and carbohydrate sources, this Grain-free cat food is an excellent choice when seeking alternative ingredients for your cat. Natural Balance L.I.D. Limited Ingredient Diets Duck and Green Pea Formula Canned Cat Food is designed to support healthy digestion and to maintain skin and coat health all while providing complete, balanced nutrition for all life stages!',2),
(13,100,null,null,'Go Cat Variety Pouches Pack','Lets show our cats that they are truly our best friends, with the new Weruva Grain-Free BFF OMG Pouches Variety Pack. Made with white breast chicken, real, sustainably caught tuna, fresh wild caught salmon, and other real, deboned meats, Weruva has created the perfect meal for our furry, purring best friends.',3),
(16,100,null,null,'Love Me Variety Pack Green','Full of duck, tuna, and white breast, skinless, and boneless chicken, this wholesome food is full of protein and free of any grains, GMOs, MSG, and carrageenan for a balanced meal in each can. Weruva Cats In the Kitchen Love Me Tender Pouches Wet Cat Food will fill your cat with love, tenderly with every meal.',3),
(69,100,null,null,'SO Dry Cat Food','Functional and beautiful, Bella Bowls are truly the perfect pet dish. Loving Pets brings new life to veterinarian-recommended stainless steel dog bowls and pet feeding dishes by combining a stainless interior with an attractive poly-resin exterior. A removable rubber base prevents spills, eliminates noise, and makes Bella Bowls fully dishwasher safe.',3),
(69,100,null,null,'Care with Chicken BlueHill MagiK','A healthy bladder starts with the right balance of vital nutrients. Excess minerals can encourage the formation of crystals in the urine, which may lead to the creation of bladder stones. They can cause discomfort and lead to more serious problems that require the care of a veterinarian.',2),
(8,100,null,null,'Mu DeoSpray Deodorizer','With Choco Spring scents lingering in the air, your cats time in the bathroom doesnt have to be so smelly anymore! This deodorizer perfumes the air and helps make the litter last longer so you and your cat can enjoy a breath of sweetly-scented air.',12),
(5,100,null,null,'Mu O-DeoSpray Deodorizer','Add an extra boost of freshness to your litter box. ARM AND HAMMER baking soda destroys odors instantly in all types of litter - so your box stays first-day fresh longer. ',12),
(40,100,null,null,'Mu X-DeoSpray Deodorizer','Change the way you think about cleaning your cats litter box with the Purina Tidy Cats BREEZE With Ammonia Blocker Litter System starter kit. This system features powerful odor control to keep your house smelling fresh and clean, and the specially designed, cat-friendly litter pellets minimize your pets from tracking litter throughout your home.',12);

-- ADDING FOREIGN KEYS

ALTER TABLE CART_ITEMS ADD FOREIGN KEY (ITEM_ID)
    REFERENCES ITEM (ITEM_ID);
ALTER TABLE CART_ITEMS ADD FOREIGN KEY (CART_ID)
    REFERENCES SHOPPING_CART (CART_ID);

ALTER TABLE ITEM_CATEGORY ADD FOREIGN KEY (ITEM_ID)
    REFERENCES ITEM (ITEM_ID);
ALTER TABLE ITEM_CATEGORY ADD FOREIGN KEY (CATEGORY_ID)
    REFERENCES CATEGORY (CATEGORY_ID);


ALTER TABLE ORDERS ADD FOREIGN KEY (CART_ID)
    REFERENCES SHOPPING_CART (CART_ID);
ALTER TABLE ORDERS ADD FOREIGN KEY (USER_ID)
    REFERENCES STORE_USER (USER_ID);


ALTER TABLE SHOPPING_CART ADD FOREIGN KEY (USER_ID)
    REFERENCES STORE_USER (USER_ID) ;
