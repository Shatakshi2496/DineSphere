-- DineSphere Database
-- Restaurant Management and Food Ordering System

-- =========================
-- CUSTOMER
-- =========================

CREATE TABLE CUSTOMER (
    Customer_ID NUMBER PRIMARY KEY,
    First_Name VARCHAR2(30) NOT NULL,
    Last_Name VARCHAR2(30) NOT NULL,
    Phone_No VARCHAR2(15),
    Email VARCHAR2(100),
    Address VARCHAR2(200)
);


-- =========================
-- RESTAURANT
-- =========================

CREATE TABLE RESTAURANT (
    Restaurant_ID NUMBER PRIMARY KEY,
    Restaurant_Name VARCHAR2(100) NOT NULL,
    Phone_No VARCHAR2(15),
    House_No VARCHAR2(20),
    Street VARCHAR2(100),
    Area VARCHAR2(100),
    City VARCHAR2(50),
    Pincode VARCHAR2(10)
);


-- =========================
-- MENU CATEGORY
-- =========================

CREATE TABLE MENU_CATEGORY (
    Category_ID NUMBER PRIMARY KEY,
    Category_Name VARCHAR2(50) NOT NULL,
    Restaurant_ID NUMBER NOT NULL,

    CONSTRAINT fk_category_restaurant
        FOREIGN KEY (Restaurant_ID)
        REFERENCES RESTAURANT(Restaurant_ID)
);


-- =========================
-- MENU ITEM
-- =========================

CREATE TABLE MENU_ITEM (
    Item_ID NUMBER PRIMARY KEY,
    Item_Name VARCHAR2(100) NOT NULL,
    Description VARCHAR2(300),
    Price NUMBER(10,2) NOT NULL,
    Availability_Status VARCHAR2(20),
    Category_ID NUMBER NOT NULL,

    CONSTRAINT fk_item_category
        FOREIGN KEY (Category_ID)
        REFERENCES MENU_CATEGORY(Category_ID),

    CONSTRAINT chk_item_price
        CHECK (Price >= 0)
);


-- =========================
-- FOOD ORDER
-- =========================

CREATE TABLE FOOD_ORDER (
    Order_ID NUMBER PRIMARY KEY,
    Customer_ID NUMBER NOT NULL,
    Restaurant_ID NUMBER NOT NULL,
    Order_DateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Order_Status VARCHAR2(30),
    Delivery_Address VARCHAR2(200),

    CONSTRAINT fk_order_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES CUSTOMER(Customer_ID),

    CONSTRAINT fk_order_restaurant
        FOREIGN KEY (Restaurant_ID)
        REFERENCES RESTAURANT(Restaurant_ID)
);


-- =========================
-- PAYMENT
-- =========================

CREATE TABLE PAYMENT (
    Payment_ID NUMBER PRIMARY KEY,
    Order_ID NUMBER UNIQUE NOT NULL,
    Payment_Mode VARCHAR2(30),
    Paid_Amount NUMBER(10,2),
    Payment_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Payment_Status VARCHAR2(30),

    CONSTRAINT fk_payment_order
        FOREIGN KEY (Order_ID)
        REFERENCES FOOD_ORDER(Order_ID),

    CONSTRAINT chk_paid_amount
        CHECK (Paid_Amount >= 0)
);


-- =========================
-- DELIVERY
-- =========================

CREATE TABLE DELIVERY (
    Delivery_ID NUMBER PRIMARY KEY,
    Pickup_Time TIMESTAMP,
    Delivered_Time TIMESTAMP,
    Delivery_Status VARCHAR2(30),
    Agent_ID NUMBER
);


-- =========================
-- DELIVERY AGENT
-- =========================

CREATE TABLE DELIVERY_AGENT (
    Agent_ID NUMBER PRIMARY KEY,
    Agent_Name VARCHAR2(100) NOT NULL,
    Phone_No VARCHAR2(15),
    Vehicle_No VARCHAR2(30)
);


-- Add Delivery Agent FK after both tables exist

ALTER TABLE DELIVERY
ADD CONSTRAINT fk_delivery_agent
FOREIGN KEY (Agent_ID)
REFERENCES DELIVERY_AGENT(Agent_ID);


-- =========================
-- ORDER ITEM
-- =========================

CREATE TABLE ORDER_ITEM (
    Order_ID NUMBER,
    Item_No NUMBER,
    Item_ID NUMBER NOT NULL,
    Quantity NUMBER NOT NULL,
    Unit_Price NUMBER(10,2) NOT NULL,
    Delivery_ID NUMBER,

    CONSTRAINT pk_order_item
        PRIMARY KEY (Order_ID, Item_No),

    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (Order_ID)
        REFERENCES FOOD_ORDER(Order_ID),

    CONSTRAINT fk_orderitem_item
        FOREIGN KEY (Item_ID)
        REFERENCES MENU_ITEM(Item_ID),

    CONSTRAINT fk_orderitem_delivery
        FOREIGN KEY (Delivery_ID)
        REFERENCES DELIVERY(Delivery_ID),

    CONSTRAINT chk_quantity
        CHECK (Quantity > 0),

    CONSTRAINT chk_unit_price
        CHECK (Unit_Price >= 0)
);