--------------------------------------------------------
--  File created - Tuesday-August-18-2020   
--------------------------------------------------------
CREATE USER ECOM IDENTIFIED BY "password";
GRANT CREATE SESSION TO ECOM;
GRANT CREATE TYPE TO ECOM;
GRANT DROP ANY TYPE TO ECOM;
GRANT EXECUTE ANY TYPE TO ECOM;
ALTER USER ADMIN QUOTA UNLIMITED ON DATA;
ALTER USER ECOM QUOTA UNLIMITED ON DATA;

--------------------------------------------------------
--  DDL for Type ITEMCOUNTS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "ECOM"."ITEMCOUNTS" AS VARRAY(200) OF INTEGER;

/
--------------------------------------------------------
--  DDL for Type ITEMIDS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "ECOM"."ITEMIDS" AS VARRAY(200) OF INTEGER;

/
--------------------------------------------------------
--  DDL for Table CART_ITEMS
--------------------------------------------------------

  CREATE TABLE "ECOM"."CART_ITEMS" 
   (	"ITEM_ID" NUMBER(*,0), 
	"CART_ID" NUMBER(*,0), 
	"QUANTITY" NUMBER(*,0) DEFAULT '1'
   )  DEFAULT COLLATION "USING_NLS_COMP" SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  DDL for Table CATEGORY
--------------------------------------------------------

  CREATE TABLE "ECOM"."CATEGORY" 
   (	"CATEGORY_ID" NUMBER(*,0) GENERATED BY DEFAULT AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"CATEGORY_NAME" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP"
   )  DEFAULT COLLATION "USING_NLS_COMP" SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  DDL for Table ITEM
--------------------------------------------------------

  CREATE TABLE "ECOM"."ITEM" 
   (	"ITEM_ID" NUMBER(*,0) GENERATED BY DEFAULT AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"UNIT_PRICE" NUMBER(*,0), 
	"STOCK" NUMBER(*,0), 
	"BRAND_NAME" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP", 
	"VENDOR_NAME" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP", 
	"NAME" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP", 
	"DESCRIPTION" VARCHAR2(500 BYTE) COLLATE "USING_NLS_COMP", 
	"MAIN_CATEGORY" NUMBER(*,0)
   )  DEFAULT COLLATION "USING_NLS_COMP" SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  DDL for Table ITEM_CATEGORY
--------------------------------------------------------

  CREATE TABLE "ECOM"."ITEM_CATEGORY" 
   (	"ITEM_ID" NUMBER(*,0), 
	"CATEGORY_ID" NUMBER(*,0)
   )  DEFAULT COLLATION "USING_NLS_COMP" SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  DDL for Table ORDERS
--------------------------------------------------------

  CREATE TABLE "ECOM"."ORDERS" 
   (	"ORDER_ID" NUMBER(*,0) GENERATED BY DEFAULT AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"USER_ID" NUMBER(*,0), 
	"CART_ID" NUMBER(*,0), 
	"FINAL_ORDER_TOTAL" NUMBER(*,0) DEFAULT '0.0', 
	"SHIP_DATE" DATE, 
	"TAX" NUMBER(*,0) DEFAULT '0.0', 
	"PAYMENT_INTENT" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP"
   )  DEFAULT COLLATION "USING_NLS_COMP" SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  DDL for Table SHOPPING_CART
--------------------------------------------------------

  CREATE TABLE "ECOM"."SHOPPING_CART" 
   (	"CART_ID" NUMBER(*,0) GENERATED BY DEFAULT AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"USER_ID" NUMBER(*,0), 
	"DATE_COMPLETED" DATE, 
	"CURR_ORDER_TOTAL" NUMBER(*,0) DEFAULT '0.0', 
	"DATE_CREATED" DATE
   )  DEFAULT COLLATION "USING_NLS_COMP" SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  DDL for Table STORE_USER
--------------------------------------------------------

  CREATE TABLE "ECOM"."STORE_USER" 
   (	"USER_ID" NUMBER(*,0) GENERATED BY DEFAULT AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE , 
	"EMAIL" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP", 
	"PASSWORD" VARCHAR2(300 BYTE) COLLATE "USING_NLS_COMP", 
	"STREET_ADDR1" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP", 
	"STREET_ADDR2" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP", 
	"CITY" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP", 
	"STATE" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP", 
	"ZIPCODE" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP", 
	"USER_ROLE" VARCHAR2(50 BYTE) COLLATE "USING_NLS_COMP" DEFAULT 'ROLE_USER', 
	"FIRSTNAME" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP", 
	"LASTNAME" VARCHAR2(100 BYTE) COLLATE "USING_NLS_COMP"
   )  DEFAULT COLLATION "USING_NLS_COMP" SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  Data for Table CATEGORY
--------------------------------------------------------

REM INSERTING into ECOM.CATEGORY
SET DEFINE OFF;
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Dry Food');
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Wet Food');
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Food Pouches');
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Limited Diet');
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Auto Feeders');
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Bowls');
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Placemats');
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Storage');
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Brushes');
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Grooming Tools');
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Shampoos');
Insert into ECOM.CATEGORY (CATEGORY_NAME) values ('Cleaning Supplies');
--------------------------------------------------------
--  Data for Table ITEM
--------------------------------------------------------

REM INSERTING into ECOM.ITEM
SET DEFINE OFF;
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (44,100,null,null,'Original MuMate Bowl','Original Pet Fountain with Bonus Reservoir provides 50 oz of fresh, filtered water to your pet, with an additional Bonus 50 Ounce Reservoir. A patented free-falling stream of water entices your pet to drink more and continually aerates the water with healthful oxygen.',5);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (80,100,null,null,'Drinkwell BrandX Feeder','The Pagoda fountain continuously recirculates 70 ounces of fresh, filtered water. Best of all, the stylish ceramic design is easy to clean and looks great in your home. The upper and lower dishes provide two drinking areas for pets, and the patented dual free-falling streams aerate the water for freshness, which encourages your pet to drink more.',5);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (5,100,null,null,'Crock Small Coastal FishBowl','Standard crock small animal dish is uses a heavy weight design that eliminates movement and spillage.',6);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (6,100,null,null,'Mu Fusion Bowl','Functional and beautiful, Bella Bowls are truly the perfect pet dish. Loving Pets brings new life to veterinarian-recommended stainless steel dog bowls and pet feeding dishes by combining a stainless interior with an attractive poly-resin exterior. A removable rubber base prevents spills, eliminates noise, and makes Bella Bowls fully dishwasher safe.',6);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (39,100,null,null,'Chicken and Pomegranate Mu Cat Food','Your cats deserve the best scientifically proven food to maintain a healthy weight. Natural and Delicious Grain Free Chicken and Pomegranate Recipe Dry Cat Food does not contain any cereal or grains of any kind and is completely replaced with the highest quality protein. ',1);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (50,100,null,null,'Cat and Kitten BlueHill MagiK','Cat and Kitten recipe is a grain-free, region-inspired formula that your cat will thrive on. An excellent choice for cats of all breed and ages, this biologically appropriate recipe contains an unmatched variety of fresh regional ingredients.',1);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (50,100,null,null,'Wet Canned Mu Dry Food','Wellness Complete Health Natural Grain Free Chicken Recipe Canned Cat Food is made with 100% Human Grade Ingredients and uses delicious fruits and vegetables which contain vitamins and antioxidants to help maintain your cats healthy immune system. ',2);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (40,100,null,null,'Green Pea Formula Mu Cat Food','Designed with a limited number of premium protein and carbohydrate sources, this Grain-free cat food is an excellent choice when seeking alternative ingredients for your cat. Natural Balance L.I.D. Limited Ingredient Diets Duck and Green Pea Formula Canned Cat Food is designed to support healthy digestion and to maintain skin and coat health all while providing complete, balanced nutrition for all life stages!',2);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (13,100,null,null,'Go Cat Variety Pouches Pack','Lets show our cats that they are truly our best friends, with the new Weruva Grain-Free BFF OMG Pouches Variety Pack. Made with white breast chicken, real, sustainably caught tuna, fresh wild caught salmon, and other real, deboned meats, Weruva has created the perfect meal for our furry, purring best friends.',3);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (16,100,null,null,'Love Me Variety Pack Green','Full of duck, tuna, and white breast, skinless, and boneless chicken, this wholesome food is full of protein and free of any grains, GMOs, MSG, and carrageenan for a balanced meal in each can. Weruva Cats In the Kitchen Love Me Tender Pouches Wet Cat Food will fill your cat with love, tenderly with every meal.',3);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (69,100,null,null,'SO Dry Cat Food','Functional and beautiful, Bella Bowls are truly the perfect pet dish. Loving Pets brings new life to veterinarian-recommended stainless steel dog bowls and pet feeding dishes by combining a stainless interior with an attractive poly-resin exterior. A removable rubber base prevents spills, eliminates noise, and makes Bella Bowls fully dishwasher safe.',3);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (69,100,null,null,'Care with Chicken BlueHill MagiK','A healthy bladder starts with the right balance of vital nutrients. Excess minerals can encourage the formation of crystals in the urine, which may lead to the creation of bladder stones. They can cause discomfort and lead to more serious problems that require the care of a veterinarian.',2);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (8,100,null,null,'Mu DeoSpray Deodorizer','With Choco Spring scents lingering in the air, your cats time in the bathroom doesnt have to be so smelly anymore! This deodorizer perfumes the air and helps make the litter last longer so you and your cat can enjoy a breath of sweetly-scented air.',12);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (5,100,null,null,'Mu O-DeoSpray Deodorizer','Add an extra boost of freshness to your litter box. ARM AND HAMMER baking soda destroys odors instantly in all types of litter - so your box stays first-day fresh longer. ',12);
Insert into ECOM.ITEM (UNIT_PRICE,STOCK,BRAND_NAME,VENDOR_NAME,NAME,DESCRIPTION,MAIN_CATEGORY) values (40,100,null,null,'Mu X-DeoSpray Deodorizer','Change the way you think about cleaning your cats litter box with the Purina Tidy Cats BREEZE With Ammonia Blocker Litter System starter kit. This system features powerful odor control to keep your house smelling fresh and clean, and the specially designed, cat-friendly litter pellets minimize your pets from tracking litter throughout your home.',12);
REM INSERTING into ECOM.ITEM_CATEGORY
SET DEFINE OFF;
--------------------------------------------------------
--  DDL for Index SYS_C0011836
--------------------------------------------------------

  CREATE UNIQUE INDEX "ECOM"."SYS_C0011836" ON "ECOM"."STORE_USER" ("USER_ID")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  DDL for Index SYS_C0011839
--------------------------------------------------------

  CREATE UNIQUE INDEX "ECOM"."SYS_C0011839" ON "ECOM"."SHOPPING_CART" ("CART_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  DDL for Index SYS_C0011844
--------------------------------------------------------

  CREATE UNIQUE INDEX "ECOM"."SYS_C0011844" ON "ECOM"."ITEM" ("ITEM_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  DDL for Index SYS_C0011846
--------------------------------------------------------

  CREATE UNIQUE INDEX "ECOM"."SYS_C0011846" ON "ECOM"."CATEGORY" ("CATEGORY_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  DDL for Index SYS_C0011853
--------------------------------------------------------

  CREATE UNIQUE INDEX "ECOM"."SYS_C0011853" ON "ECOM"."ITEM_CATEGORY" ("ITEM_ID", "CATEGORY_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  DDL for Index SYS_C0011859
--------------------------------------------------------

  CREATE UNIQUE INDEX "ECOM"."SYS_C0011859" ON "ECOM"."ORDERS" ("ORDER_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;

--------------------------------------------------------
--  Constraints for Table CART_ITEMS
--------------------------------------------------------

  ALTER TABLE "ECOM"."CART_ITEMS" MODIFY ("ITEM_ID" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."CART_ITEMS" MODIFY ("CART_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CATEGORY
--------------------------------------------------------

  -- ALTER TABLE "ECOM"."CATEGORY" MODIFY ("CATEGORY_ID" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."CATEGORY" ADD PRIMARY KEY ("CATEGORY_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA"  ENABLE;
--------------------------------------------------------
--  Constraints for Table ITEM
--------------------------------------------------------

  -- ALTER TABLE "ECOM"."ITEM" MODIFY ("ITEM_ID" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."ITEM" MODIFY ("UNIT_PRICE" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."ITEM" MODIFY ("STOCK" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."ITEM" ADD PRIMARY KEY ("ITEM_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA"  ENABLE;
  ALTER TABLE "ECOM"."ITEM" MODIFY ("NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ITEM_CATEGORY
--------------------------------------------------------

  ALTER TABLE "ECOM"."ITEM_CATEGORY" MODIFY ("ITEM_ID" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."ITEM_CATEGORY" MODIFY ("CATEGORY_ID" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."ITEM_CATEGORY" ADD PRIMARY KEY ("ITEM_ID", "CATEGORY_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "DATA"  ENABLE;
--------------------------------------------------------
--  Constraints for Table ORDERS
--------------------------------------------------------

  -- ALTER TABLE "ECOM"."ORDERS" MODIFY ("ORDER_ID" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."ORDERS" MODIFY ("CART_ID" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."ORDERS" ADD PRIMARY KEY ("ORDER_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA"  ENABLE;
--------------------------------------------------------
--  Constraints for Table SHOPPING_CART
--------------------------------------------------------

  -- ALTER TABLE "ECOM"."SHOPPING_CART" MODIFY ("CART_ID" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."SHOPPING_CART" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."SHOPPING_CART" ADD PRIMARY KEY ("CART_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA"  ENABLE;
--------------------------------------------------------
--  Constraints for Table STORE_USER
--------------------------------------------------------

  -- ALTER TABLE "ECOM"."STORE_USER" MODIFY ("USER_ID" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."STORE_USER" MODIFY ("EMAIL" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."STORE_USER" MODIFY ("PASSWORD" NOT NULL ENABLE);
  ALTER TABLE "ECOM"."STORE_USER" ADD PRIMARY KEY ("USER_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table CART_ITEMS
--------------------------------------------------------

  ALTER TABLE "ECOM"."CART_ITEMS" ADD FOREIGN KEY ("ITEM_ID")
	  REFERENCES "ECOM"."ITEM" ("ITEM_ID") ENABLE;
  ALTER TABLE "ECOM"."CART_ITEMS" ADD FOREIGN KEY ("CART_ID")
	  REFERENCES "ECOM"."SHOPPING_CART" ("CART_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ITEM
--------------------------------------------------------

  ALTER TABLE "ECOM"."ITEM" ADD CONSTRAINT "ITEM_CATEGORY_FK" FOREIGN KEY ("MAIN_CATEGORY")
	  REFERENCES "ECOM"."CATEGORY" ("CATEGORY_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ITEM_CATEGORY
--------------------------------------------------------

  ALTER TABLE "ECOM"."ITEM_CATEGORY" ADD FOREIGN KEY ("ITEM_ID")
	  REFERENCES "ECOM"."ITEM" ("ITEM_ID") ENABLE;
  ALTER TABLE "ECOM"."ITEM_CATEGORY" ADD FOREIGN KEY ("CATEGORY_ID")
	  REFERENCES "ECOM"."CATEGORY" ("CATEGORY_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ORDERS
--------------------------------------------------------

  ALTER TABLE "ECOM"."ORDERS" ADD FOREIGN KEY ("CART_ID")
	  REFERENCES "ECOM"."SHOPPING_CART" ("CART_ID") ENABLE;
  ALTER TABLE "ECOM"."ORDERS" ADD FOREIGN KEY ("USER_ID")
	  REFERENCES "ECOM"."STORE_USER" ("USER_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SHOPPING_CART
--------------------------------------------------------

  ALTER TABLE "ECOM"."SHOPPING_CART" ADD FOREIGN KEY ("USER_ID")
	  REFERENCES "ECOM"."STORE_USER" ("USER_ID") ENABLE;
