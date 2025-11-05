drop table Shipment;
drop table Payment;
drop table Order_Package;
drop table Order_Item;
drop table Orders;
drop table Address;
drop table Customer;
drop table Package_Item;
drop table Package;
drop table Menu_Item;
drop table Staff;
drop table Promotion;
drop table Role;
drop table Rental_Agreement;
drop table Business_Hour;
drop table Stall;

DROP TRIGGER role_on_insert;
DROP TRIGGER customer_on_insert;
DROP TRIGGER stall_on_insert;
DROP TRIGGER menu_item_on_insert;
DROP TRIGGER package_on_insert;
DROP TRIGGER staff_on_insert;
DROP TRIGGER rental_agreement_on_insert;
DROP TRIGGER business_hour_on_insert;
DROP TRIGGER package_item_on_insert;
DROP TRIGGER order_on_insert;
DROP TRIGGER order_item_on_insert;
DROP TRIGGER order_package_on_insert;
DROP TRIGGER payment_on_insert;
DROP TRIGGER address_on_insert;
DROP TRIGGER shipment_on_insert;
DROP TRIGGER promotion_on_insert;

drop SEQUENCE role_sequence;
drop SEQUENCE customer_sequence;
drop SEQUENCE stall_sequence;
drop SEQUENCE menu_item_sequence;
drop SEQUENCE package_sequence;
drop SEQUENCE staff_sequence;
drop SEQUENCE rental_agreement_sequence;
drop SEQUENCE business_hour_sequence;
drop SEQUENCE package_item_sequence;
drop SEQUENCE order_sequence;
drop SEQUENCE order_item_sequence;
drop SEQUENCE order_package_sequence;
drop SEQUENCE payment_sequence;
drop SEQUENCE address_sequence;
drop SEQUENCE shipment_sequence;
drop SEQUENCE promotion_sequence;

Drop index order_item_menu_item_id_idx;
Drop index idx_customer_id;
Drop index staff_stall_id_idx;
Drop index address_state_idx;

CREATE TABLE Role (
    role_id NUMBER(10) NOT NULL,
    role_name VARCHAR(50) NOT NULL,
    description VARCHAR(100) NOT NULL,
    CONSTRAINT role_pk PRIMARY KEY (role_id)
);

CREATE TABLE Customer (
    customer_id NUMBER(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    phone_number VARCHAR(12) NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    CONSTRAINT customer_pk PRIMARY KEY (customer_id)
);

CREATE TABLE Stall (
    stall_id NUMBER(10) NOT NULL,
    rental_price DECIMAL(10, 2),
    rental_status VARCHAR(20) DEFAULT 'Available',
    stall_name VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    CONSTRAINT stall_pk PRIMARY KEY (stall_id)
);

CREATE TABLE Menu_Item (
    menu_item_id NUMBER(10) NOT NULL,
    stall_id NUMBER(10) NOT NULL,
    menu_item_name VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock NUMBER(10) NOT NULL,
    CONSTRAINT menu_item_pk PRIMARY KEY (menu_item_id),
    CONSTRAINT menu_item_fk FOREIGN KEY (stall_id) REFERENCES Stall(stall_id)
);

CREATE TABLE Package (
    package_id NUMBER(10) NOT NULL,
    stall_id NUMBER(10) NOT NULL,
    package_name VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock NUMBER(10) NOT NULL,
    CONSTRAINT package_pk PRIMARY KEY (package_id),
    CONSTRAINT package_fk FOREIGN KEY (stall_id) REFERENCES Stall(stall_id)
);

CREATE TABLE Staff (
    staff_id NUMBER(10) NOT NULL,
    stall_id NUMBER(10) NOT NULL,
    role_id NUMBER(10)NOT NULL,
    staff_name VARCHAR(50) NOT NULL,
    hourly_rate DECIMAL(10, 2) NOT NULL,
    CONSTRAINT staff_pk PRIMARY KEY (staff_id),
    CONSTRAINT staff_fk1 FOREIGN KEY (stall_id) REFERENCES Stall(stall_id),
    CONSTRAINT staff_fk2 FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

CREATE TABLE Rental_Agreement (
    rental_agreement_id NUMBER(10) NOT NULL,
    stall_id NUMBER(10) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    rent_amount DECIMAL(10, 2) NOT NULL,
    payment_frequency VARCHAR(50) NOT NULL,
    deposit_amount DECIMAL(10, 2) NOT NULL,
    created_at DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    owner_name VARCHAR(100) NOT NULL,
    owner_ic VARCHAR(14) NOT NULL,
    contact_phone VARCHAR(13) NOT NULL,
    CONSTRAINT rental_agreement_pk PRIMARY KEY (rental_agreement_id),
    CONSTRAINT rental_agreement_fk FOREIGN KEY (stall_id) REFERENCES Stall(stall_id)
);

CREATE TABLE Business_Hour (
    business_hour_id NUMBER(10) NOT NULL,
    stall_id NUMBER(10) NOT NULL,
    day VARCHAR2(16) NOT NULL,
    open_time INTERVAL DAY TO SECOND, -- UPDATED
    close_time INTERVAL DAY TO SECOND, -- UPDATED
    CONSTRAINT business_hour_pk PRIMARY KEY (business_hour_id),
    CONSTRAINT business_hour_fk FOREIGN KEY (stall_id) REFERENCES Stall(stall_id)
);


CREATE TABLE Promotion (
    promotion_id NUMBER(10) NOT NULL,
    stall_id NUMBER(10) NOT NULL,
    promotion_name VARCHAR2(100) NOT NULL,
    amount_reached DECIMAL(10, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    discount_rate DECIMAL(3, 2) NOT NULL,
    CONSTRAINT promotion_pk PRIMARY KEY (promotion_id, stall_id),
    CONSTRAINT promotion_fk FOREIGN KEY (stall_id) REFERENCES Stall(stall_id)
);

CREATE TABLE Package_Item (
    package_item_id NUMBER(10) NOT NULL,
    menu_item_id NUMBER(10) NOT NULL,
    package_id NUMBER(10) NOT NULL,
    quantity NUMBER(5) NOT NULL,
    CONSTRAINT package_item_pk PRIMARY KEY (package_item_id),
    CONSTRAINT package_item_fk1 FOREIGN KEY (menu_item_id) REFERENCES Menu_Item(menu_item_id),
    CONSTRAINT package_item_fk2 FOREIGN KEY (package_id) REFERENCES Package(package_id)
);

CREATE TABLE Orders (
    order_id NUMBER(10) NOT NULL,
    customer_id NUMBER(10),
    status VARCHAR(50) DEFAULT 'Created',
    order_date TIMESTAMP NOT NULL,
    type VARCHAR(20) NOT NULL,
    rating NUMBER(1),
    rating_comment VARCHAR(100),
    remark VARCHAR(100),
    CONSTRAINT order_pk PRIMARY KEY (order_id),
    CONSTRAINT order_fk FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Order_Item (
    order_item_id NUMBER(10) NOT NULL,
    menu_item_id NUMBER(10) NOT NULL,
    order_id NUMBER(10) NOT NULL,
    quantity NUMBER(5) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT order_item_pk PRIMARY KEY (order_item_id),
    CONSTRAINT order_item_fk1 FOREIGN KEY (menu_item_id) REFERENCES Menu_Item(menu_item_id),
    CONSTRAINT order_item_fk2 FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Order_Package (
    order_package_id NUMBER(10) NOT NULL,
    package_id NUMBER(10) NOT NULL,
    order_id NUMBER(10) NOT NULL,
    quantity NUMBER(5) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT order_package_pk PRIMARY KEY (order_package_id),
    CONSTRAINT order_package_fk1 FOREIGN KEY (package_id) REFERENCES Package(package_id),
    CONSTRAINT order_package_fk2 FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Payment (
    payment_id NUMBER(10) NOT NULL,
    order_id NUMBER(10) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) NOT NULL,
    paid_at TIMESTAMP NOT NULL, -- Pending to remove millisecond
    status VARCHAR(50),
    CONSTRAINT payment_pk PRIMARY KEY (payment_id),
    CONSTRAINT payment_fk FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Address (
    address_id NUMBER(10) NOT NULL,
    customer_id NUMBER(10) NOT NULL,
    full_name CHAR(50) NOT NULL,
    phone_number VARCHAR(12) NOT NULL,
    state VARCHAR(50) NOT NULL,
    area VARCHAR(50) NOT NULL,
    postal_code VARCHAR(5) NOT NULL,
    detailed_address VARCHAR(80) NOT NULL,
    CONSTRAINT address_pk PRIMARY KEY (address_id),
    CONSTRAINT address_fk FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Shipment (
    shipment_id NUMBER(10) NOT NULL,
    order_id NUMBER(10) NOT NULL,
    address_id NUMBER(10) NOT NULL,
    delivery_fee DECIMAL(10, 2) NOT NULL,
    shipping_date DATE NOT NULL,
    status VARCHAR(50),
    CONSTRAINT shipment_pk PRIMARY KEY (shipment_id),
    CONSTRAINT shipment_fk1 FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT shipment_fk2 FOREIGN KEY (address_id) REFERENCES Address(address_id)
);


-- Creating sequences
CREATE SEQUENCE role_sequence;
CREATE SEQUENCE customer_sequence;
CREATE SEQUENCE stall_sequence;
CREATE SEQUENCE menu_item_sequence;
CREATE SEQUENCE package_sequence;
CREATE SEQUENCE staff_sequence;
CREATE SEQUENCE rental_agreement_sequence;
CREATE SEQUENCE business_hour_sequence;
CREATE SEQUENCE package_item_sequence;
CREATE SEQUENCE order_sequence;
CREATE SEQUENCE order_item_sequence;
CREATE SEQUENCE order_package_sequence;
CREATE SEQUENCE payment_sequence;
CREATE SEQUENCE address_sequence;
CREATE SEQUENCE shipment_sequence;
CREATE SEQUENCE promotion_sequence;


-- Trigger for Role table
CREATE OR REPLACE TRIGGER role_on_insert
BEFORE INSERT ON Role
FOR EACH ROW
BEGIN
  SELECT role_sequence.nextval
  INTO :new.role_id
  FROM dual;
END;
/

-- Trigger for Customer table
CREATE OR REPLACE TRIGGER customer_on_insert
BEFORE INSERT ON Customer
FOR EACH ROW
BEGIN
  SELECT customer_sequence.nextval
  INTO :new.customer_id
  FROM dual;
END;
/

-- Trigger for Stall table
CREATE OR REPLACE TRIGGER stall_on_insert
BEFORE INSERT ON Stall
FOR EACH ROW
BEGIN
  SELECT stall_sequence.nextval
  INTO :new.stall_id
  FROM dual;
END;
/

-- Trigger for Menu_Item table
CREATE OR REPLACE TRIGGER menu_item_on_insert
BEFORE INSERT ON Menu_Item
FOR EACH ROW
BEGIN
  SELECT menu_item_sequence.nextval
  INTO :new.menu_item_id
  FROM dual;
END;
/

-- Trigger for Package table
CREATE OR REPLACE TRIGGER package_on_insert
BEFORE INSERT ON Package
FOR EACH ROW
BEGIN
  SELECT package_sequence.nextval
  INTO :new.package_id
  FROM dual;
END;
/

-- Trigger for Staff table
CREATE OR REPLACE TRIGGER staff_on_insert
BEFORE INSERT ON Staff
FOR EACH ROW
BEGIN
  SELECT staff_sequence.nextval
  INTO :new.staff_id
  FROM dual;
END;
/

-- Trigger for Rental_Agreement table
CREATE OR REPLACE TRIGGER rental_agreement_on_insert
BEFORE INSERT ON Rental_Agreement
FOR EACH ROW
BEGIN
  SELECT rental_agreement_sequence.nextval
  INTO :new.rental_agreement_id
  FROM dual;
END;
/

-- Trigger for Business_Hour table
CREATE OR REPLACE TRIGGER business_hour_on_insert
BEFORE INSERT ON Business_Hour
FOR EACH ROW
BEGIN
  SELECT business_hour_sequence.nextval
  INTO :new.business_hour_id
  FROM dual;
END;
/

-- Trigger for Promotion table
-- Note: Promotion table uses a composite primary key, so a trigger for auto-increment might not be directly applicable.

-- Trigger for Package_Item table
CREATE OR REPLACE TRIGGER package_item_on_insert
BEFORE INSERT ON Package_Item
FOR EACH ROW
BEGIN
  SELECT package_item_sequence.nextval
  INTO :new.package_item_id
  FROM dual;
END;
/

-- Trigger for Order table
CREATE OR REPLACE TRIGGER order_on_insert
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
  SELECT order_sequence.nextval
  INTO :new.order_id
  FROM dual;
END;
/

-- Trigger for Order_Item table
CREATE OR REPLACE TRIGGER order_item_on_insert
BEFORE INSERT ON Order_Item
FOR EACH ROW
BEGIN
  SELECT order_item_sequence.nextval
  INTO :new.order_item_id
  FROM dual;
END;
/

-- Trigger for Order_Package table
CREATE OR REPLACE TRIGGER order_package_on_insert
BEFORE INSERT ON Order_Package
FOR EACH ROW
BEGIN
  SELECT order_package_sequence.nextval
  INTO :new.order_package_id
  FROM dual;
END;
/

-- Trigger for Payment table
CREATE OR REPLACE TRIGGER payment_on_insert
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
  SELECT payment_sequence.nextval
  INTO :new.payment_id
  FROM dual;
END;
/

-- Trigger for Address table
CREATE OR REPLACE TRIGGER address_on_insert
BEFORE INSERT ON Address
FOR EACH ROW
BEGIN
  SELECT address_sequence.nextval
  INTO :new.address_id
  FROM dual;
END;
/

-- Trigger for Shipment table
CREATE OR REPLACE TRIGGER shipment_on_insert
BEFORE INSERT ON Shipment
FOR EACH ROW
BEGIN
  SELECT shipment_sequence.nextval
  INTO :new.shipment_id
  FROM dual;
END;
/

-- Trigger for Promotion table
CREATE OR REPLACE TRIGGER promotion_on_insert
BEFORE INSERT ON Promotion
FOR EACH ROW
BEGIN
  SELECT promotion_sequence.nextval
  INTO :new.promotion_id
  FROM dual;
END;
/
















-------------------------------------- 
--to reset a sequence
--DROP SEQUENCE WHAT_SEQUENCE;
--CREATE SEQUENCE WHAT_SEQUENCE START WITH 1;





--3.2 Sample Records (10 sample Records for each table)
-- Role (Base Table) 
-- Inserting Manager role
INSERT INTO Role (role_name, description) VALUES 
('No Role', 'Default role for staff with no specific role');
INSERT INTO Role (role_name, description) VALUES 
('Chef', 'Responsible for food preparation and cooking');
INSERT INTO Role (role_name, description) VALUES
('Manager', 'Responsible for overall management of the stall');
INSERT INTO Role (role_name, description) VALUES 
('Cashier', 'Responsible for handling customer payments');
INSERT INTO Role (role_name, description) VALUES 
('Cleaner', 'Responsible for maintaining cleanliness in the stall');
INSERT INTO Role (role_name, description) VALUES 
('Assistant Manager', 'Assists the manager in overseeing stall operations');
INSERT INTO Role (role_name, description) VALUES 
('Sous Chef', 'Assists the head chef in food preparation and cooking');
INSERT INTO Role (role_name, description) VALUES 
('Assistant Cashier', 'Assists the cashier in handling customer payments');
INSERT INTO Role (role_name, description) VALUES 
('Sanitation Inspector', 'Responsible for ensuring compliance with sanitation standards');
INSERT INTO Role (role_name, description) VALUES 
('Inventory Manager', 'Responsible for managing stock and inventory levels');
INSERT INTO Role (role_name, description) VALUES 
('Customer Service Representative', 'Responsible for addressing customer inquiries and concerns');


-- Customer (Base Table) 
INSERT INTO Customer (name, username, password, phone_number) VALUES 
('John Doe', 'johndoe', 'password123', '0123456789');
INSERT INTO Customer (name, username, password, phone_number) VALUES 
('Jane Smith', 'janesmith', 'pass123', '0198765432');
INSERT INTO Customer (name, username, password, phone_number) VALUES 
('David Tan', 'davidtan', 'davidpass', '0165432890');
INSERT INTO Customer (name, username, password, phone_number) VALUES 
('Emily Lim', 'emilylim', 'emilypass', '0112345678');
INSERT INTO Customer (name, username, password, phone_number) VALUES 
('Michael Ng', 'michaelng', 'mikepass', '0187654321');
INSERT INTO Customer (name, username, password, phone_number) VALUES 
('Karen Lee', 'karenlee', 'karenpass', '0134567890');
INSERT INTO Customer (name, username, password, phone_number) VALUES 
('Steven Wong', 'stevenwong', 'stevepass', '0176543210');
INSERT INTO Customer (name, username, password, phone_number) VALUES 
('Michelle Chin', 'michellechin', 'michpass', '0154321098');
INSERT INTO Customer (name, username, password, phone_number) VALUES 
('Andrew Loh', 'andrewloh', 'andypass', '0143210987');
INSERT INTO Customer (name, username, password, phone_number) VALUES 
('Samantha Foo', 'samanthafoo', 'sampass', '0109876543');


-- Stall (Base Table) 
INSERT INTO Stall (rental_price, stall_name, category) VALUES
(500.00, 'Golden Dragon', 'Chinese Cuisine');
INSERT INTO Stall (rental_price, stall_name, category) VALUES
(450.00, 'Spring Garden', 'Dim Sum');
INSERT INTO Stall (rental_price, stall_name, category) VALUES
(550.00, 'Lotus Blossom', 'Noodles');
INSERT INTO Stall (rental_price, stall_name, category) VALUES
(400.00, 'Panda Express', 'Rice Dishes');
INSERT INTO Stall (rental_price, stall_name, category) VALUES
(600.00, 'Dragon Palace', 'Seafood');
INSERT INTO Stall (rental_price, stall_name, category) VALUES
(500.00, 'Great Wall Kitchen', 'Vegetarian');
INSERT INTO Stall (rental_price, stall_name, category) VALUES
(550.00, 'Red Lantern', 'Barbecue');
INSERT INTO Stall (rental_price, stall_name, category) VALUES
(450.00, 'Chopsticks Paradise', 'Soup');
INSERT INTO Stall (rental_price, stall_name, category) VALUES
(400.00, 'Fortune Garden', 'Desserts');
INSERT INTO Stall (rental_price, stall_name, category) VALUES
(600.00, 'Emperor''s Delight', 'Beverages');

-- Menu_Item (Base Table) 
insert into Menu_Item  (stall_id, menu_item_name, type, price, stock) values (5, 'Steamed Fish with Ginger', 'Rice Dish', 8.8, 40);
insert into Menu_Item (stall_id, menu_item_name, type, price, stock) values (1, 'Egg Fried Rice', 'Rice Dish', 13.46, 54);
insert into Menu_Item (stall_id, menu_item_name, type, price, stock) values (5, 'Egg Fried Rice', 'Rice Dish', 18.33, 36);
insert into Menu_Item (stall_id, menu_item_name, type, price, stock) values (6, 'Sweet and Sour Chicken', 'Appetizer', 15.88, 42);
insert into Menu_Item (stall_id, menu_item_name, type, price, stock) values (8, 'Egg Fried Rice', 'Appetizer', 8.75, 32);
insert into Menu_Item (stall_id, menu_item_name, type, price, stock) values (4, 'Siu Mai', 'Dim Sum', 8.8, 36);
insert into Menu_Item (stall_id, menu_item_name, type, price, stock) values (6, 'Kung Pao Chicken', 'Noodles', 8.61, 47);
insert into Menu_Item (stall_id, menu_item_name, type, price, stock) values (1, 'Kung Pao Chicken', 'Seafood', 12.56, 36);
insert into Menu_Item (stall_id, menu_item_name, type, price, stock) values (10, 'Steamed Fish with Ginger', 'Rice Dish', 13.63, 36);
insert into Menu_Item (stall_id, menu_item_name, type, price, stock) values (6, 'Steamed Fish with Ginger', 'Noodles', 13.86, 50);


-- Package (Base Table)
insert into Package (stall_id, package_name, type, price, stock) values (1, 'Forbidden City Feast', 'Soup', 23.39, 19);
insert into Package (stall_id, package_name, type, price, stock) values (1, 'Fortune Cookie Combo', 'Platter', 28.49, 15);
insert into Package (stall_id, package_name, type, price, stock) values (6, 'Fortune Cookie Combo', 'Soup', 21.41, 30);
insert into Package (stall_id, package_name, type, price, stock) values (8, 'Fortune Cookie Combo', 'Soup', 19.22, 29);
insert into Package (stall_id, package_name, type, price, stock) values (3, 'Imperial Dynasty Platter', 'Set Meal', 11.21, 15);
insert into Package (stall_id, package_name, type, price, stock) values (7, 'Golden Panda Feast', 'Soup', 26.92, 20);
insert into Package (stall_id, package_name, type, price, stock) values (4, 'Fortune Cookie Combo', 'Soup', 30.08, 12);
insert into Package (stall_id, package_name, type, price, stock) values (10, 'Golden Panda Feast', 'Combo Meal', 27.55, 30);
insert into Package (stall_id, package_name, type, price, stock) values (3, 'Phoenix Rising Combo', 'Combo Meal', 29.93, 21);
insert into Package (stall_id, package_name, type, price, stock) values (7, 'Silk Road Sampler', 'Combo Meal', 20.82, 21);

-- Staff (Base Table) 
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (1, 1, 'Arvy', 9.69);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (1, 2, 'Towney', 9.08);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (2, 3, 'Michale', 13.5);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (2, 4, 'Harriot', 11.09);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (3, 5, 'Berti', 9.25);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (3, 6, 'Shannon', 14.23);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (4, 7, 'Ola', 9.1);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (4, 8, 'Dukey', 9.38);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (5, 9, 'Billy', 9.93);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (5, 10, 'Harvey', 14.05);

insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (6, 2, 'Emma', 9.69);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (6, 2, 'Liam', 9.08);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (7, 2, 'Sofia', 13.5);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (7, 2, 'Ethan', 11.09);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (8, 2, 'Olivia', 9.25);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (8, 2, 'Mason', 14.23);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (9, 2, 'Peter', 9.1);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (10, 2, 'Mike', 9.38);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (10, 2, 'Kevin', 9.93);
insert into Staff (stall_id, role_id, staff_name, hourly_rate) values (10, 2, 'Alvin', 14.05);


-- Rental_Agreement (Base Table) 
INSERT INTO Rental_Agreement (stall_id, start_date, end_date, rent_amount, payment_frequency, deposit_amount, created_at, status, owner_name, owner_ic, contact_phone) 
VALUES (1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2023-01-01', 'YYYY-MM-DD'), 600.00, 'Monthly', 1500.00, TO_DATE('2021-12-12', 'YYYY-MM-DD'), 'Active', 'Lee Seng', '870101145678', '012-3456789');
INSERT INTO Rental_Agreement (stall_id, start_date, end_date, rent_amount, payment_frequency, deposit_amount, created_at, status, owner_name, owner_ic, contact_phone) 
VALUES (2, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2023-06-01', 'YYYY-MM-DD'), 6600.00, 'Yearly', 1400.00, TO_DATE('2021-11-20', 'YYYY-MM-DD'), 'Active', 'Wong Mei Ling', '900315127890', '011-2345678');
INSERT INTO Rental_Agreement (stall_id, start_date, end_date, rent_amount, payment_frequency, deposit_amount, created_at, status, owner_name, owner_ic, contact_phone) 
VALUES (3, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2023-03-01', 'YYYY-MM-DD'), 8400.00, 'Yearly', 1600.00, TO_DATE('2021-10-25', 'YYYY-MM-DD'), 'Active', 'Tan Ah Kow', '880522101234', '019-8765432');
INSERT INTO Rental_Agreement (stall_id, start_date, end_date, rent_amount, payment_frequency, deposit_amount, created_at, status, owner_name, owner_ic, contact_phone) 
VALUES (4, TO_DATE('2022-08-01', 'YYYY-MM-DD'), TO_DATE('2023-08-01', 'YYYY-MM-DD'), 6000.00, 'Yearly', 1200.00, TO_DATE('2021-09-30', 'YYYY-MM-DD'), 'Active', 'Lim Ah Seng', '910701084321', '016-5432890');
INSERT INTO Rental_Agreement (stall_id, start_date, end_date, rent_amount, payment_frequency, deposit_amount, created_at, status, owner_name, owner_ic, contact_phone) 
VALUES (5, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2023-05-01', 'YYYY-MM-DD'), 650.00, 'Monthly', 1300.00, TO_DATE('2021-08-15', 'YYYY-MM-DD'), 'Active', 'Chong Mei Ling', '890401116789', '018-7654321');
INSERT INTO Rental_Agreement (stall_id, start_date, end_date, rent_amount, payment_frequency, deposit_amount, created_at, status, owner_name, owner_ic, contact_phone) 
VALUES (6, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2023-02-01', 'YYYY-MM-DD'), 6600.00, 'Yearly', 1300.00, TO_DATE('2021-07-20', 'YYYY-MM-DD'), 'Active', 'Tan Ah Kow', '900925089876', '017-6543210');
INSERT INTO Rental_Agreement (stall_id, start_date, end_date, rent_amount, payment_frequency, deposit_amount, created_at, status, owner_name, owner_ic, contact_phone) 
VALUES (7, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2023-09-01', 'YYYY-MM-DD'), 500.00, 'Monthly', 1100.00, TO_DATE('2021-06-25', 'YYYY-MM-DD'), 'Active', 'Lee Siew Ling', '930210132345', '016-5432890');
INSERT INTO Rental_Agreement (stall_id, start_date, end_date, rent_amount, payment_frequency, deposit_amount, created_at, status, owner_name, owner_ic, contact_phone) 
VALUES (8, TO_DATE('2022-12-01', 'YYYY-MM-DD'), TO_DATE('2023-12-01', 'YYYY-MM-DD'), 600.00, 'Monthly', 1400.00, TO_DATE('2021-05-30', 'YYYY-MM-DD'), 'Active', 'Chong Ah Kow', '900515108765', '019-8765432');
INSERT INTO Rental_Agreement (stall_id, start_date, end_date, rent_amount, payment_frequency, deposit_amount, created_at, status, owner_name, owner_ic, contact_phone) 
VALUES (9, TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2023-07-01', 'YYYY-MM-DD'), 550.00, 'Monthly', 1200.00, TO_DATE('2021-04-15', 'YYYY-MM-DD'), 'Active', 'Lim Mei Ling', '910625123456', '012-3456789');
INSERT INTO Rental_Agreement (stall_id, start_date, end_date, rent_amount, payment_frequency, deposit_amount, created_at, status, owner_name, owner_ic, contact_phone) 
VALUES (10, TO_DATE('2022-04-01', 'YYYY-MM-DD'), TO_DATE('2023-04-01', 'YYYY-MM-DD'), 700.00, 'Monthly', 1500.00, TO_DATE('2021-03-20', 'YYYY-MM-DD'), 'Active', 'Wong Siew Ling', '920330117890', '011-2345678');




-- Business_Hour (Base Table) 
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (1, 'Monday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (1, 'Tuesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (1, 'Wednesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (1, 'Thursday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (1, 'Friday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (1, 'Saturday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (1, 'Sunday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);

INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (2, 'Monday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (2, 'Tuesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (2, 'Wednesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (2, 'Thursday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (2, 'Friday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (2, 'Saturday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (2, 'Sunday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);

INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (3, 'Monday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (3, 'Tuesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (3, 'Wednesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (3, 'Thursday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (3, 'Friday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (3, 'Saturday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (3, 'Sunday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);

INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (4, 'Monday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (4, 'Tuesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (4, 'Wednesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (4, 'Thursday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (4, 'Friday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (4, 'Saturday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (4, 'Sunday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);

INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (5, 'Monday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (5, 'Tuesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (5, 'Wednesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (5, 'Thursday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (5, 'Friday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (5, 'Saturday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (5, 'Sunday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);

INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (6, 'Monday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (6, 'Tuesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (6, 'Wednesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (6, 'Thursday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (6, 'Friday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (6, 'Saturday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (6, 'Sunday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);

INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (7, 'Monday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (7, 'Tuesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (7, 'Wednesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (7, 'Thursday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (7, 'Friday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (7, 'Saturday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (7, 'Sunday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);

INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (8, 'Monday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (8, 'Tuesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (8, 'Wednesday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (8, 'Thursday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (8, 'Friday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (8, 'Saturday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (8, 'Sunday', INTERVAL '08:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);

INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (9, 'Monday', INTERVAL '09:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (9, 'Tuesday', INTERVAL '09:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (9, 'Wednesday', INTERVAL '09:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (9, 'Thursday', INTERVAL '09:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (9, 'Friday', INTERVAL '09:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (9, 'Saturday', INTERVAL '09:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (9, 'Sunday', INTERVAL '09:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);

INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (10, 'Monday', INTERVAL '010:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (10, 'Tuesday', INTERVAL '010:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (10, 'Wednesday', INTERVAL '010:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (10, 'Thursday', INTERVAL '010:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (10, 'Friday', INTERVAL '010:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (10, 'Saturday', INTERVAL '010:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);
INSERT INTO Business_Hour (stall_id, day, open_time, close_time) 
VALUES (10, 'Sunday', INTERVAL '010:00:00' HOUR TO SECOND, INTERVAL '20:00:00' HOUR TO SECOND);





-- Promotion (Child Table)
-- For stall_id 1
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (1, 'Weekend Special', 25.00, TO_DATE('2022-04-01', 'YYYY-MM-DD'), TO_DATE('2022-05-01', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (1, 'Combo Meal Deal', 35.00, TO_DATE('2022-03-15', 'YYYY-MM-DD'), TO_DATE('2022-05-15', 'YYYY-MM-DD'), 0.18);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (1, 'Happy Hour', 20.00, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 0.10);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (1, 'Family Meal Deal', 45.00, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-05-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (1, 'Student Discount', 15.00, TO_DATE('2022-02-15', 'YYYY-MM-DD'), TO_DATE('2022-04-15', 'YYYY-MM-DD'), 0.08);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (1, 'Summer Special', 40.00, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 0.25);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (1, 'New Year Offer', 30.00, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-31', 'YYYY-MM-DD'), 0.15);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (1, 'Mid-Autumn Festival Promotion', 50.00, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2022-09-30', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (1, 'Winter Warmers', 40.00, TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (1, 'Back to School Special', 25.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 0.12);

-- For stall_id 2
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (2, 'Weekend Dim Sum Delight', 30.00, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (2, 'Family Dim Sum Combo', 40.00, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 0.18);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (2, 'Student Dim Sum Special', 20.00, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-03-01', 'YYYY-MM-DD'), 0.10);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (2, 'Mid-Year Dim Sum Madness', 50.00, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-07-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (2, 'Summer Dim Sum Spectacular', 35.00, TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 0.25);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (2, 'Back to School Dim Sum Deal', 25.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (2, 'Autumn Dim Sum Fest', 45.00, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2022-10-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (2, 'Winter Dim Sum Warmers', 40.00, TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2022-12-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (2, 'Christmas Dim Sum Special', 30.00, TO_DATE('2022-12-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), 0.15);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (2, 'New Year Dim Sum Discount', 30.00, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-31', 'YYYY-MM-DD'), 0.15);

-- For stall_id 3
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (3, 'Weekend Noodle Bonanza', 25.00, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (3, 'Family Noodle Combo', 40.00, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 0.18);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (3, 'Student Noodle Special', 20.00, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-03-01', 'YYYY-MM-DD'), 0.10);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (3, 'Mid-Year Noodle Madness', 50.00, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-07-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (3, 'Summer Noodle Spectacular', 35.00, TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 0.25);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (3, 'Back to School Noodle Deal', 25.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (3, 'Autumn Noodle Fest', 45.00, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2022-10-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (3, 'Winter Noodle Warmers', 40.00, TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2022-12-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (3, 'Christmas Noodle Special', 30.00, TO_DATE('2022-12-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), 0.15);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (3, 'New Year Noodle Discount', 30.00, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-31', 'YYYY-MM-DD'), 0.15);

-- For stall_id 4
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (4, 'Weekend Dim Sum Delight', 25.00, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (4, 'Family Dim Sum Combo', 40.00, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 0.18);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (4, 'Student Dim Sum Special', 20.00, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-03-01', 'YYYY-MM-DD'), 0.10);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (4, 'Mid-Year Dim Sum Madness', 50.00, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-07-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (4, 'Summer Dim Sum Spectacular', 35.00, TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 0.25);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (4, 'Back to School Dim Sum Deal', 25.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (4, 'Autumn Dim Sum Fest', 45.00, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2022-10-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (4, 'Winter Dim Sum Warmers', 40.00, TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2022-12-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (4, 'Christmas Dim Sum Special', 30.00, TO_DATE('2022-12-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), 0.15);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (4, 'New Year Dim Sum Discount', 30.00, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-31', 'YYYY-MM-DD'), 0.15);

-- For stall_id 5
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (5, 'Weekend Seafood Special', 25.00, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (5, 'Family Seafood Combo', 40.00, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 0.18);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (5, 'Student Seafood Special', 20.00, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-03-01', 'YYYY-MM-DD'), 0.10);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (5, 'Mid-Year Seafood Madness', 50.00, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-07-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (5, 'Summer Seafood Spectacular', 35.00, TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 0.25);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (5, 'Back to School Seafood Deal', 25.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (5, 'Autumn Seafood Fest', 45.00, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2022-10-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (5, 'Winter Seafood Warmers', 40.00, TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2022-12-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (5, 'Christmas Seafood Special', 30.00, TO_DATE('2022-12-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), 0.15);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (5, 'New Year Seafood Discount', 30.00, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-31', 'YYYY-MM-DD'), 0.15);

-- For stall_id 6
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (6, 'Weekend Noodle Delight', 25.00, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (6, 'Family Noodle Combo', 40.00, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 0.18);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (6, 'Student Noodle Special', 20.00, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-03-01', 'YYYY-MM-DD'), 0.10);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (6, 'Mid-Year Noodle Madness', 50.00, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-07-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (6, 'Summer Noodle Spectacular', 35.00, TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 0.25);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (6, 'Back to School Noodle Deal', 25.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (6, 'Autumn Noodle Fest', 45.00, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2022-10-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (6, 'Winter Noodle Warmers', 40.00, TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2022-12-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (6, 'Christmas Noodle Special', 30.00, TO_DATE('2022-12-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), 0.15);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (6, 'New Year Noodle Discount', 30.00, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-31', 'YYYY-MM-DD'), 0.15);

-- For stall_id 7
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (7, 'Weekend BBQ Special', 25.00, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (7, 'Family BBQ Combo', 40.00, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 0.18);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (7, 'Student BBQ Special', 20.00, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-03-01', 'YYYY-MM-DD'), 0.10);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (7, 'Mid-Year BBQ Madness', 50.00, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-07-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (7, 'Summer BBQ Spectacular', 35.00, TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 0.25);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (7, 'Back to School BBQ Deal', 25.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (7, 'Autumn BBQ Fest', 45.00, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2022-10-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (7, 'Winter BBQ Warmers', 40.00, TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2022-12-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (7, 'Christmas BBQ Special', 30.00, TO_DATE('2022-12-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), 0.15);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (7, 'New Year BBQ Discount', 30.00, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-31', 'YYYY-MM-DD'), 0.15);

-- For stall_id 8
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (8, 'Weekend Appetizer Special', 25.00, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (8, 'Family Appetizer Combo', 40.00, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 0.18);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (8, 'Student Appetizer Special', 20.00, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-03-01', 'YYYY-MM-DD'), 0.10);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (8, 'Mid-Year Appetizer Madness', 50.00, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-07-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (8, 'Summer Appetizer Spectacular', 35.00, TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 0.25);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (8, 'Back to School Appetizer Deal', 25.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (8, 'Autumn Appetizer Fest', 45.00, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2022-10-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (8, 'Winter Appetizer Warmers', 40.00, TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2022-12-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (8, 'Christmas Appetizer Special', 30.00, TO_DATE('2022-12-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), 0.15);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (8, 'New Year Appetizer Discount', 30.00, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-31', 'YYYY-MM-DD'), 0.15);

-- For stall_id 9
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (9, 'Weekend Dessert Special', 25.00, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (9, 'Family Dessert Combo', 40.00, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 0.18);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (9, 'Student Dessert Special', 20.00, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-03-01', 'YYYY-MM-DD'), 0.10);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (9, 'Mid-Year Dessert Madness', 50.00, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-07-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (9, 'Summer Dessert Spectacular', 35.00, TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 0.25);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (9, 'Back to School Dessert Deal', 25.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (9, 'Autumn Dessert Fest', 45.00, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2022-10-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (9, 'Winter Dessert Warmers', 40.00, TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2022-12-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (9, 'Christmas Dessert Special', 30.00, TO_DATE('2022-12-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), 0.15);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (9, 'New Year Dessert Discount', 30.00, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-31', 'YYYY-MM-DD'), 0.15);

-- For stall_id 10
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (10, 'Weekend Rice Dish Special', 25.00, TO_DATE('2022-05-01', 'YYYY-MM-DD'), TO_DATE('2022-06-01', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (10, 'Family Rice Dish Combo', 40.00, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'), 0.18);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (10, 'Student Rice Dish Special', 20.00, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-03-01', 'YYYY-MM-DD'), 0.10);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (10, 'Mid-Year Rice Dish Madness', 50.00, TO_DATE('2022-06-01', 'YYYY-MM-DD'), TO_DATE('2022-07-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (10, 'Summer Rice Dish Spectacular', 35.00, TO_DATE('2022-07-01', 'YYYY-MM-DD'), TO_DATE('2022-08-01', 'YYYY-MM-DD'), 0.25);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (10, 'Back to School Rice Dish Deal', 25.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), TO_DATE('2022-09-15', 'YYYY-MM-DD'), 0.12);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (10, 'Autumn Rice Dish Fest', 45.00, TO_DATE('2022-09-01', 'YYYY-MM-DD'), TO_DATE('2022-10-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (10, 'Winter Rice Dish Warmers', 40.00, TO_DATE('2022-11-01', 'YYYY-MM-DD'), TO_DATE('2022-12-01', 'YYYY-MM-DD'), 0.20);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (10, 'Christmas Rice Dish Special', 30.00, TO_DATE('2022-12-01', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'), 0.15);
INSERT INTO Promotion (stall_id, promotion_name, amount_reached, start_date, end_date, discount_rate) 
VALUES (10, 'New Year Rice Dish Discount', 30.00, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-31', 'YYYY-MM-DD'), 0.15);


-- Package_Item (Associative Table) 
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 6, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 7, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 9, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 10, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 8, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 9, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 8, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 9, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 7, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 10, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 1, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 3, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 4, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 6, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 7, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 10, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 1, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 3, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 4, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 6, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 7, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 9, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 7, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 8, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 10, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 2, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 3, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 5, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 6, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 8, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 9, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 1, 2);

INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 6, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 7, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 9, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 10, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 8, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 9, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 8, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 9, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 7, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 10, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 1, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 3, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 4, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 6, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 7, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 10, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 1, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 3, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 4, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 6, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 7, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 9, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 7, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 8, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 10, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 2, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 3, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 5, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 6, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 8, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 9, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 1, 2);

INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 1, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 6, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 7, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 9, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 10, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 8, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 9, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 8, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 9, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 7, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 10, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 1, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 3, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 4, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 6, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 7, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 10, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 1, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 2, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 3, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 4, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 5, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 6, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 7, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 8, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 9, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 1, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 2, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 3, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 4, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 5, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 6, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 7, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 8, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 9, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 10, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(1, 2, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(2, 3, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(3, 4, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(4, 5, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(5, 6, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(6, 7, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(7, 8, 2);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(8, 9, 3);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(9, 10, 1);
INSERT INTO Package_Item (menu_item_id, package_id, quantity) VALUES
(10, 1, 2);


-- Orders (Base Table) 
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (1, TO_DATE('2022-01-03 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dine-In', 4, 'Good service and tasty food');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (2, TO_DATE('2022-01-05 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Takeaway', 5, 'Quick and friendly service');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (3, TO_DATE('2022-01-07 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 3, 'Late delivery but food was delicious');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (4, TO_DATE('2022-01-10 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dine-In', 5, 'Excellent experience overall');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (5, TO_DATE('2022-01-12 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Takeaway', 4, 'Food was good but portion size could be larger');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (6, TO_DATE('2022-01-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dine-In', 4, 'Food was delicious but service was slow');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (7, TO_DATE('2022-01-17 18:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Takeaway', 5, 'Quick service and great value for money');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (8, TO_DATE('2022-01-20 20:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 4, 'Delivery arrived slightly late but food was still warm');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (9, TO_DATE('2022-01-22 13:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dine-In', 3, 'Food quality was inconsistent');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (10, TO_DATE('2022-01-25 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Takeaway', 5, 'Excellent food and friendly staff');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (1, TO_DATE('2022-01-26 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 4, 'Late delivery but food was delicious');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (2, TO_DATE('2022-01-27 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 3, 'Late delivery but food was delicious');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (4, TO_DATE('2022-01-28 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 5, 'Food was very delicious');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (5, TO_DATE('2022-01-29 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 4, 'Food was delicious');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (6, TO_DATE('2022-01-30 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 3, 'Late delivery but food was delicious');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (7, TO_DATE('2022-01-31 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 4, 'Late delivery but food was delicious');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (8, TO_DATE('2022-02-01 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 3, 'Late delivery but food was delicious');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (9, TO_DATE('2022-02-05 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 5, 'Food was very delicious');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (10, TO_DATE('2022-02-07 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 4, 'Food was delicious');
INSERT INTO Orders (customer_id, order_date, type, rating, remark) 
VALUES (10, TO_DATE('2022-02-09 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivery', 3, 'Late delivery but food was delicious');


-- Order_Item (Associative Table)
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 1, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 2, 1, 6.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 3, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 4, 2, 21.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 5, 1, 18.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 5, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 6, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 7, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 8, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 9, 2, 30.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 10, 1, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 1, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 2, 1, 6.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 3, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 4, 2, 21.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 5, 1, 18.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 5, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 6, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 7, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 8, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 10, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 1, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 2, 2, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 3, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 4, 3, 16.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 5, 2, 37.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 6, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 7, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 8, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 1, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 2, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 3, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 4, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 5, 2, 30.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 6, 1, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 7, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 8, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 9, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 10, 1, 18.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 2, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 3, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 4, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 5, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 6, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 7, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 8, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 9, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 10, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 1, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 1, 1, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 2, 3, 16.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 3, 1, 6.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 4, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 5, 2, 21.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 6, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 7, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 8, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 9, 2, 37.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 10, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 3, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 4, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 5, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 6, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 7, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 8, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 9, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 10, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 1, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 2, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 4, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 5, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 6, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 7, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 8, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 9, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 10, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 1, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 2, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 3, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 5, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 6, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 7, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 8, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 9, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 1, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 2, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 3, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 4, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 6, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 7, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 8, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 9, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 10, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 1, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 2, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 3, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 4, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 5, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 1, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 2, 1, 6.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 3, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 4, 2, 21.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 5, 1, 18.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 5, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 6, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 7, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 8, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 9, 2, 30.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 10, 1, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 1, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 2, 1, 6.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 3, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 4, 2, 21.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 5, 1, 18.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 5, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 6, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 7, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 8, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 10, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 1, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 2, 2, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 3, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 4, 3, 16.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 5, 2, 37.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 6, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 7, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 8, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 1, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 2, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 3, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 4, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 5, 2, 30.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 6, 1, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 7, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 8, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 9, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 10, 1, 18.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 2, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 3, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 4, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 5, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 6, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 7, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 8, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 9, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 10, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 1, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 1, 1, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 2, 3, 16.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 3, 1, 6.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 4, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 5, 2, 21.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 6, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 7, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 8, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 9, 2, 37.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 10, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 3, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 4, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 5, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 6, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 7, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 8, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 9, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 10, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 1, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 2, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 4, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 5, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 6, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 7, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 8, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 9, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 10, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 1, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 2, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 3, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 5, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 6, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 7, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 8, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 9, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 1, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 2, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 3, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 4, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 6, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 7, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 8, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 9, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 10, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 1, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 2, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 3, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 4, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 5, 1, 15.00);

INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 1, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 2, 1, 6.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 3, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 4, 2, 21.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 5, 1, 18.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 5, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 6, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 7, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 8, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 9, 2, 30.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 10, 1, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 1, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 2, 1, 6.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 3, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 4, 2, 21.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 5, 1, 18.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 5, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 6, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 7, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 8, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 10, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 1, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 2, 2, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 3, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 4, 3, 16.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 5, 2, 37.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 6, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 7, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 8, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 1, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 2, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 3, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 4, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 5, 2, 30.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 6, 1, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 7, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 8, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 9, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 10, 1, 18.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 2, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 3, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 4, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 5, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 6, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 7, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 8, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 9, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 10, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 1, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 1, 1, 12.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 2, 3, 16.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 3, 1, 6.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 4, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 5, 2, 21.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 6, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 7, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 8, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 9, 2, 37.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 10, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 3, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 4, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 5, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 6, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 7, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 8, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 9, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 10, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 1, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 2, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 4, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 5, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 6, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 7, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 8, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 9, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 10, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 1, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 2, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 3, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 5, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 6, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 7, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 8, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 9, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 1, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 2, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 3, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 4, 1, 15.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (1, 6, 2, 25.80);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (2, 7, 1, 5.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (3, 8, 2, 13.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (4, 9, 1, 8.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (5, 10, 1, 10.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (6, 1, 2, 17.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (7, 2, 1, 11.90);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (8, 3, 2, 19.00);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (9, 4, 1, 9.50);
INSERT INTO Order_Item (menu_item_id, order_id, quantity, subtotal) VALUES (10, 5, 1, 15.00);


-- Order_Package (Associative Table) 
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 2, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 3, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 4, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 5, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 7, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 8, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 9, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 10, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 1, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 2, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 3, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 4, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 5, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 6, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 7, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 8, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 9, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 10, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 1, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 2, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 3, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 4, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 5, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 6, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 7, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 8, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 9, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 10, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 1, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 2, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 3, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 5, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 7, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 8, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 9, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 10, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 6, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 7, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 8, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 9, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 10, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 1, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 2, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 3, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 4, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 5, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 6, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 7, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 8, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 9, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 10, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 1, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 2, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 3, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 4, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 5, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 6, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 7, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 8, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 9, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 10, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 2, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 3, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 4, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 6, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 7, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 8, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 9, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 10, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 1, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 2, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 3, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 4, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 7, 3, 105.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 8, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 9, 3, 90.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 24.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 2, 50.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 2, 3, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 3, 2, 36.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 3, 60.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 7, 2, 70.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 8, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 9, 4, 120.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 24.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 3, 75.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 2, 2, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 3, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 3, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 3, 60.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 7, 2, 70.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 8, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 9, 4, 120.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 24.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 3, 75.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 2, 2, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 3, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 3, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 7, 3, 105.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 8, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 9, 3, 90.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 24.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 2, 50.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 2, 3, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 3, 2, 36.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 6, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 7, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 8, 3, 60.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 9, 2, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 10, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 3, 45.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 2, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 3, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 4, 80.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 5, 2, 50.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 6, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 7, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 8, 3, 45.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 9, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 10, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 3, 45.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 2, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 3, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 4, 80.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 5, 2, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 6, 2, 50.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 7, 3, 75.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 8, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 9, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 10, 3, 45.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 1, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 2, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 3, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 4, 4, 80.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 5, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 2, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 3, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 4, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 5, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 7, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 8, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 9, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 10, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 1, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 2, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 3, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 4, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 5, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 6, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 7, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 8, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 9, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 10, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 1, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 2, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 3, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 4, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 5, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 6, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 7, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 8, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 9, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 10, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 1, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 2, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 3, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 5, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 7, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 8, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 9, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 10, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 6, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 7, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 8, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 9, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 10, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 1, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 2, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 3, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 4, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 5, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 6, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 7, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 8, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 9, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 10, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 1, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 2, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 3, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 4, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 5, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 6, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 7, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 8, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 9, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 10, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 2, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 3, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 4, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 6, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 7, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 8, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 9, 1, 12.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 10, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 1, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 2, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 3, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 4, 1, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 7, 3, 105.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 8, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 9, 3, 90.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 24.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 2, 50.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 2, 3, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 3, 2, 36.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 3, 60.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 7, 2, 70.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 8, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 9, 4, 120.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 24.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 3, 75.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 2, 2, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 3, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 3, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 3, 60.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 7, 2, 70.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 8, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 9, 4, 120.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 24.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 3, 75.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 2, 2, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 3, 1, 18.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 3, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 6, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 7, 3, 105.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 8, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 9, 3, 90.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 10, 2, 24.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 2, 50.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 2, 3, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 3, 2, 36.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 5, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 6, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 7, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 8, 3, 60.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 9, 2, 35.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 10, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 3, 45.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 2, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 3, 1, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 4, 80.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 5, 2, 50.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 6, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 7, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 8, 3, 45.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 9, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 10, 1, 20.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 1, 3, 45.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 2, 2, 30.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 3, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 4, 4, 80.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 5, 2, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (7, 6, 2, 50.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (4, 7, 3, 75.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (1, 8, 1, 15.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (9, 9, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (3, 10, 3, 45.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (6, 1, 1, 10.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (8, 2, 2, 40.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (5, 3, 1, 25.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (2, 4, 4, 80.00);
INSERT INTO Order_Package (package_id, order_id, quantity, subtotal) VALUES (10, 5, 2, 30.00);


-- Payment (Child Table)
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (1, 'Cash', 25.80, 0.00, TO_DATE('2022-01-03 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (2, 'Credit Card', 6.50, 0.00, TO_DATE('2022-01-05 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Online Transfer', 11.90, 0.00, TO_DATE('2022-01-07 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (4, 'Cash', 21.80, 0.00, TO_DATE('2022-01-10 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (5, 'Cash', 29.90, 3.10, TO_DATE('2022-01-12 19:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (6, 'Cash', 17.00, 0.00, TO_DATE('2022-01-15 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (7, 'Credit Card', 8.50, 0.00, TO_DATE('2022-01-17 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (8, 'Online Transfer', 9.50, 3.50, TO_DATE('2022-01-20 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (9, 'Cash', 30.00, 0.00, TO_DATE('2022-01-22 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (10, 'Cash', 25.90, 0.00, TO_DATE('2022-01-25 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (1, 'Cash', 25.80, 0.00, TO_DATE('2022-01-03 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (2, 'Credit Card', 6.50, 0.00, TO_DATE('2022-01-05 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Online Transfer', 11.90, 4.10, TO_DATE('2022-01-07 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (4, 'Cash', 21.80, 2.10, TO_DATE('2022-01-10 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (5, 'Cash', 29.90, 5.10, TO_DATE('2022-01-12 19:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (6, 'Cash', 17.00, 3.50, TO_DATE('2022-01-15 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (7, 'Credit Card', 8.50, 0.00, TO_DATE('2022-01-17 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (8, 'Online Transfer', 9.50, 0.00, TO_DATE('2022-01-20 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (9, 'Cash', 30.00, 0.00, TO_DATE('2022-01-22 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (10, 'Cash', 25.90, 0.00, TO_DATE('2022-01-25 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (1, 'Credit Card', 15.50, 0.00, TO_DATE('2022-01-28 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (2, 'Cash', 8.75, 1.10, TO_DATE('2022-02-01 13:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Credit Card', 20.20, 0.00, TO_DATE('2022-02-05 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (4, 'Cash', 12.30, 0.00, TO_DATE('2022-02-10 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (5, 'Online Transfer', 18.60, 3.60, TO_DATE('2022-02-12 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (6, 'Cash', 13.75, 4.10, TO_DATE('2022-02-15 16:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (7, 'Credit Card', 29.40, 0.00, TO_DATE('2022-02-17 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (8, 'Cash', 16.90, 0.00, TO_DATE('2022-02-20 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (9, 'Online Transfer', 22.75, 0.00, TO_DATE('2022-02-22 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (10, 'Cash', 35.80, 0.00, TO_DATE('2022-02-25 17:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (1, 'Cash', 27.50, 0.00, TO_DATE('2022-02-28 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (2, 'Credit Card', 18.25, 0.00, TO_DATE('2022-03-01 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Online Transfer', 23.70, 0.00, TO_DATE('2022-03-05 11:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (4, 'Cash', 10.80, 0.00, TO_DATE('2022-03-10 18:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (5, 'Cash', 31.20, 0.00, TO_DATE('2022-03-12 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (6, 'Credit Card', 15.90, 2.10, TO_DATE('2022-03-15 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (7, 'Online Transfer', 28.75, 0.00, TO_DATE('2022-03-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (8, 'Cash', 19.40, 0.00, TO_DATE('2022-03-20 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (9, 'Cash', 26.50, 0.00, TO_DATE('2022-03-22 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (10, 'Credit Card', 37.80, 0.00, TO_DATE('2022-03-25 19:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (1, 'Credit Card', 22.50, 0.00, TO_DATE('2022-04-01 16:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (2, 'Online Transfer', 14.75, 0.00, TO_DATE('2022-04-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Cash', 19.90, 0.00, TO_DATE('2022-04-07 14:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (4, 'Cash', 12.80, 0.00, TO_DATE('2022-04-10 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (5, 'Credit Card', 28.50, 0.00, TO_DATE('2022-04-12 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (6, 'Online Transfer', 15.60, 0.00, TO_DATE('2022-04-15 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (7, 'Cash', 27.90, 0.00, TO_DATE('2022-04-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (8, 'Cash', 18.20, 0.00, TO_DATE('2022-04-20 16:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (9, 'Credit Card', 25.80, 0.00, TO_DATE('2022-04-22 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (10, 'Online Transfer', 34.70, 0.00, TO_DATE('2022-04-25 19:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (1, 'Cash', 19.50, 0.00, TO_DATE('2022-04-28 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (2, 'Credit Card', 16.80, 0.00, TO_DATE('2022-05-01 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Online Transfer', 21.90, 0.00, TO_DATE('2022-05-03 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (4, 'Cash', 27.00, 0.00, TO_DATE('2022-05-06 13:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (5, 'Cash', 15.25, 0.00, TO_DATE('2022-05-09 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (6, 'Credit Card', 32.90, 0.00, TO_DATE('2022-05-12 16:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (7, 'Online Transfer', 19.70, 0.00, TO_DATE('2022-05-15 10:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (8, 'Cash', 24.50, 0.00, TO_DATE('2022-05-18 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (9, 'Cash', 11.20, 0.00, TO_DATE('2022-05-21 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (10, 'Credit Card', 28.75, 0.00, TO_DATE('2022-05-24 18:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (1, 'Online Transfer', 22.60, 0.00, TO_DATE('2022-05-27 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (2, 'Cash', 17.40, 0.00, TO_DATE('2022-05-30 10:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Credit Card', 29.80, 0.00, TO_DATE('2022-06-02 15:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (4, 'Online Transfer', 13.70, 0.00, TO_DATE('2022-06-05 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (5, 'Cash', 16.90, 0.00, TO_DATE('2022-06-08 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (6, 'Credit Card', 18.50, 0.00, TO_DATE('2022-06-11 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (7, 'Cash', 25.20, 0.00, TO_DATE('2022-06-14 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (8, 'Online Transfer', 30.80, 0.00, TO_DATE('2022-06-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (9, 'Cash', 22.75, 0.00, TO_DATE('2022-06-20 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (10, 'Credit Card', 18.90, 0.00, TO_DATE('2022-06-23 16:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (1, 'Credit Card', 27.50, 0.00, TO_DATE('2022-06-26 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (2, 'Cash', 19.20, 0.00, TO_DATE('2022-06-29 13:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Online Transfer', 14.80, 0.00, TO_DATE('2022-07-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (4, 'Cash', 33.25, 0.00, TO_DATE('2022-07-05 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (5, 'Credit Card', 26.90, 0.00, TO_DATE('2022-07-08 11:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (6, 'Online Transfer', 20.50, 0.00, TO_DATE('2022-07-11 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (7, 'Cash', 16.75, 0.00, TO_DATE('2022-07-14 16:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (8, 'Credit Card', 35.90, 0.00, TO_DATE('2022-07-17 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (9, 'Online Transfer', 18.25, 0.00, TO_DATE('2022-07-20 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (10, 'Cash', 22.90, 0.00, TO_DATE('2022-07-23 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (1, 'Online Transfer', 19.50, 0.00, TO_DATE('2022-07-26 18:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (2, 'Credit Card', 28.70, 0.00, TO_DATE('2022-07-29 11:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Cash', 15.80, 0.00, TO_DATE('2022-08-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (4, 'Online Transfer', 30.25, 0.00, TO_DATE('2022-08-04 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (5, 'Cash', 24.90, 0.00, TO_DATE('2022-08-07 16:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (6, 'Credit Card', 18.50, 0.00, TO_DATE('2022-08-10 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (7, 'Online Transfer', 26.75, 0.00, TO_DATE('2022-08-13 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (8, 'Cash', 33.90, 0.00, TO_DATE('2022-08-16 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (9, 'Credit Card', 14.25, 0.00, TO_DATE('2022-08-19 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (10, 'Online Transfer', 27.90, 0.00, TO_DATE('2022-08-22 10:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (1, 'Cash', 19.80, 0.00, TO_DATE('2022-08-25 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (2, 'Credit Card', 32.50, 0.00, TO_DATE('2022-08-28 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Online Transfer', 22.90, 0.00, TO_DATE('2022-08-31 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (4, 'Cash', 26.75, 0.00, TO_DATE('2022-09-03 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (5, 'Credit Card', 18.90, 0.00, TO_DATE('2022-09-06 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (6, 'Online Transfer', 29.50, 0.00, TO_DATE('2022-09-09 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Cash', 15.20, 0.00, TO_DATE('2022-09-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Credit Card', 27.80, 0.00, TO_DATE('2022-09-15 18:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Online Transfer', 14.50, 0.00, TO_DATE('2022-09-18 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');
INSERT INTO Payment (order_id, payment_method, amount, discount_amount, paid_at, status) 
VALUES (3, 'Cash', 33.25, 0.00, TO_DATE('2022-09-21 14:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Paid');


-- Address (Base Table)
INSERT INTO Address (customer_id, full_name, phone_number, state, area, postal_code, detailed_address) 
VALUES (1, 'John Doe', '012-3456789', 'Selangor', 'Petaling Jaya', '47810', '12A, Jalan SS2/2');
INSERT INTO Address (customer_id, full_name, phone_number, state, area, postal_code, detailed_address) 
VALUES (2, 'Jane Smith', '019-8765432', 'Selangor', 'Subang Jaya', '47500', '45, Jalan SS15/4');
INSERT INTO Address (customer_id, full_name, phone_number, state, area, postal_code, detailed_address) 
VALUES (3, 'David Tan', '016-5432890', 'Kuala Lumpur', 'KL City Centre', '50450', '88, Jalan Ampang');
INSERT INTO Address (customer_id, full_name, phone_number, state, area, postal_code, detailed_address) 
VALUES (4, 'Emily Lim', '011-2345678', 'Penang', 'Georgetown', '10200', '7, Lebuh Chulia');
INSERT INTO Address (customer_id, full_name, phone_number, state, area, postal_code, detailed_address) 
VALUES (5, 'Michael Ng', '018-7654321', 'Johor', 'Johor Bahru', '80000', '29, Jalan Dato Onn');
INSERT INTO Address (customer_id, full_name, phone_number, state, area, postal_code, detailed_address) 
VALUES (6, 'Michael Lee', '013-4567890', 'Kuala Lumpur', 'Bukit Bintang', '55100', '20, Jalan Alor');
INSERT INTO Address (customer_id, full_name, phone_number, state, area, postal_code, detailed_address) 
VALUES (7, 'Samantha Tan', '010-9876543', 'Selangor', 'Shah Alam', '40100', '15, Persiaran Kayangan');
INSERT INTO Address (customer_id, full_name, phone_number, state, area, postal_code, detailed_address) 
VALUES (8, 'Kevin Goh', '014-3210987', 'Johor', 'Skudai', '81300', '35, Jalan Sutera');
INSERT INTO Address (customer_id, full_name, phone_number, state, area, postal_code, detailed_address) 
VALUES (9, 'Jessica Lim', '015-4321098', 'Penang', 'Bayan Lepas', '11900', '42, Lebuh Farquhar');
INSERT INTO Address (customer_id, full_name, phone_number, state, area, postal_code, detailed_address) 
VALUES (10, 'Andrew Yap', '016-6543210', 'Kuala Lumpur', 'Kepong', '52100', '8, Jalan Metro Perdana Barat 1');

-- Shipment (Child Table)
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 1, 5.00, TO_DATE('2021-12-03', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 2, 3.00, TO_DATE('2021-12-03', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 3, 7.00, TO_DATE('2021-12-03', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 4, 6.00, TO_DATE('2021-12-03', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 5, 8.00, TO_DATE('2021-12-03', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (6, 11, 5.00, TO_DATE('2021-12-03', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (7, 12, 3.00, TO_DATE('2021-12-07', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (8, 13, 7.00, TO_DATE('2021-12-07', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (9, 14, 6.00, TO_DATE('2021-12-07', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (10, 15, 8.00, TO_DATE('2021-12-07', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (11, 6, 8.00, TO_DATE('2021-12-15', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (12, 7, 9.00, TO_DATE('2021-12-15', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (13, 8, 10.00, TO_DATE('2021-12-15', 'YYYY-MM-DD'), 'Cancelled');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (14, 9, 11.00, TO_DATE('2021-12-15', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (15, 10, 12.00, TO_DATE('2021-12-20', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (16, 1, 13.00, TO_DATE('2021-12-20', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (17, 2, 14.00, TO_DATE('2021-12-20', 'YYYY-MM-DD'), 'Cancelled');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (18, 3, 15.00, TO_DATE('2021-12-25', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (19, 4, 13.00, TO_DATE('2021-12-25', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (20, 5, 6.00, TO_DATE('2021-12-25', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 7, 5.00, TO_DATE('2021-12-27', 'YYYY-MM-DD'), 'Cancelled');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 8, 7.00, TO_DATE('2021-12-27', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 9, 9.00, TO_DATE('2021-12-27', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 10, 8.00, TO_DATE('2021-12-27', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 1, 5.00, TO_DATE('2021-12-30', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (6, 2, 11.00, TO_DATE('2021-12-30', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (7, 3, 12.00, TO_DATE('2021-12-30', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (8, 1, 5.00, TO_DATE('2021-12-30', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (9, 2, 11.00, TO_DATE('2021-12-30', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (10, 3, 12.00, TO_DATE('2021-12-30', 'YYYY-MM-DD'), 'Delivered');

INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (11, 1, 5.00, TO_DATE('2022-01-03', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (12, 2, 0.00, TO_DATE('2022-01-05', 'YYYY-MM-DD'), 'Cancelled');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (13, 3, 7.00, TO_DATE('2022-01-07', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (14, 4, 6.00, TO_DATE('2022-01-10', 'YYYY-MM-DD'), 'In Transit');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (15, 5, 8.00, TO_DATE('2022-01-12', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (16, 11, 5.00, TO_DATE('2022-01-15', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (17, 12, 3.00, TO_DATE('2022-01-17', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (18, 13, 7.00, TO_DATE('2022-01-20', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (19, 14, 6.00, TO_DATE('2022-01-22', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (20, 15, 8.00, TO_DATE('2022-01-25', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 6, 8.00, TO_DATE('2022-01-28', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 7, 9.00, TO_DATE('2022-01-30', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 8, 10.00, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 9, 11.00, TO_DATE('2022-02-05', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 10, 12.00, TO_DATE('2022-02-08', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (6, 1, 13.00, TO_DATE('2022-02-10', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (7, 2, 14.00, TO_DATE('2022-02-13', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (8, 3, 15.00, TO_DATE('2022-02-15', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (9, 4, 13.00, TO_DATE('2022-02-18', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (10, 5, 6.00, TO_DATE('2022-02-20', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 7, 5.00, TO_DATE('2022-02-23', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 8, 7.00, TO_DATE('2022-02-25', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 9, 9.00, TO_DATE('2022-02-28', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 10, 8.00, TO_DATE('2022-03-03', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 1, 5.00, TO_DATE('2022-03-05', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (6, 2, 11.00, TO_DATE('2022-03-08', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (7, 3, 12.00, TO_DATE('2022-03-10', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (8, 4, 13.00, TO_DATE('2022-03-13', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (9, 5, 5.00, TO_DATE('2022-03-15', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (10, 6, 4.00, TO_DATE('2022-03-18', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 8, 5.00, TO_DATE('2022-03-20', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 9, 15.00, TO_DATE('2022-03-23', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 10, 11.00, TO_DATE('2022-03-25', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 1, 12.00, TO_DATE('2022-03-28', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 2, 12.00, TO_DATE('2022-03-30', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (6, 3, 14.00, TO_DATE('2022-04-02', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (7, 4, 6.00, TO_DATE('2022-04-05', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (8, 5, 7.00, TO_DATE('2022-04-08', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (9, 6, 9.00, TO_DATE('2022-04-10', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (10, 7, 9.00, TO_DATE('2022-04-13', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 9, 7.00, TO_DATE('2022-04-15', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 10, 5.00, TO_DATE('2022-04-18', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 1, 8.00, TO_DATE('2022-04-20', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 2, 8.00, TO_DATE('2022-04-23', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 3, 7.00, TO_DATE('2022-04-25', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (6, 4, 8.00, TO_DATE('2022-04-28', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (7, 5, 9.00, TO_DATE('2022-04-30', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (8, 6, 5.00, TO_DATE('2022-05-03', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (9, 7, 5.00, TO_DATE('2022-05-05', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (10, 8, 11.00, TO_DATE('2022-05-08', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 10, 11.00, TO_DATE('2022-05-10', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 1, 12.00, TO_DATE('2022-05-13', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 2, 11.00, TO_DATE('2022-05-15', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 3, 13.00, TO_DATE('2022-05-18', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 4, 5.00, TO_DATE('2022-05-20', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (6, 5, 8.00, TO_DATE('2022-05-23', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (7, 6, 8.00, TO_DATE('2022-05-25', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (8, 7, 9.00, TO_DATE('2022-05-28', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (9, 8, 6.00, TO_DATE('2022-05-30', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (10, 9, 7.00, TO_DATE('2022-06-02', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 3, 8.00, TO_DATE('2022-06-05', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 4, 9.00, TO_DATE('2022-06-07', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 5, 6.00, TO_DATE('2022-06-10', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 6, 6.00, TO_DATE('2022-06-12', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 7, 7.00, TO_DATE('2022-06-15', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (6, 8, 7.00, TO_DATE('2022-06-17', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (7, 9, 8.00, TO_DATE('2022-06-20', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (8, 10, 8.00, TO_DATE('2022-06-22', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (9, 1, 5.00, TO_DATE('2022-06-25', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (10, 2, 5.00, TO_DATE('2022-06-27', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 5, 6.00, TO_DATE('2022-06-30', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 6, 6.00, TO_DATE('2022-07-02', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 7, 7.00, TO_DATE('2022-07-05', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 8, 11.00, TO_DATE('2022-07-07', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 9, 11.00, TO_DATE('2022-07-10', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (6, 10, 11.00, TO_DATE('2022-07-12', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (7, 1, 6.00, TO_DATE('2022-07-15', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (8, 2, 7.00, TO_DATE('2022-07-17', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (9, 3, 6.00, TO_DATE('2022-07-20', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (10, 4, 8.00, TO_DATE('2022-07-22', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 6, 9.00, TO_DATE('2022-07-25', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 7, 5.00, TO_DATE('2022-07-27', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 8, 10.00, TO_DATE('2022-07-30', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 9, 10.00, TO_DATE('2022-08-01', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 10, 10.00, TO_DATE('2022-08-03', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (6, 1, 11.00, TO_DATE('2022-08-06', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (7, 2, 10.00, TO_DATE('2022-08-08', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (8, 3, 8.00, TO_DATE('2022-08-11', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (9, 4, 9.00, TO_DATE('2022-08-13', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (10, 5, 7.00, TO_DATE('2022-08-16', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 7, 7.00, TO_DATE('2022-08-18', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 8, 5.00, TO_DATE('2022-08-21', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 9, 5.00, TO_DATE('2022-08-23', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 10, 6.00, TO_DATE('2022-08-26', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 1, 6.00, TO_DATE('2022-08-28', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (6, 2, 7.00, TO_DATE('2022-08-31', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (7, 3, 8.00, TO_DATE('2022-09-02', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (8, 4, 9.00, TO_DATE('2022-09-05', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (9, 5, 10.00, TO_DATE('2022-09-07', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (10, 6, 10.00, TO_DATE('2022-09-10', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (1, 6, 5.00, TO_DATE('2022-09-01', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (2, 9, 7.00, TO_DATE('2022-09-10', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (3, 5, 9.00, TO_DATE('2022-08-15', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (4, 7, 10.00, TO_DATE('2022-08-05', 'YYYY-MM-DD'), 'Delivered');
INSERT INTO Shipment (order_id, address_id, delivery_fee, shipping_date, status) 
VALUES (5, 9, 8.00, TO_DATE('2022-09-10', 'YYYY-MM-DD'), 'Delivered');

COMMIT;

SELECT COUNT(*) AS NoOfRole FROM Role;
SELECT COUNT(*) AS NoOfCustomer FROM Customer;
SELECT COUNT(*) AS NoOfStall FROM Stall;
SELECT COUNT(*) AS NoOfMenu_Item FROM Menu_Item;
SELECT COUNT(*) AS NoOfPackage FROM Package;
SELECT COUNT(*) AS NoOfStaff FROM Staff;
SELECT COUNT(*) AS NoOfRental_Agreement FROM Rental_Agreement;
SELECT COUNT(*) AS NoOfBusiness_Hour FROM Business_Hour;
SELECT COUNT(*) AS NoOfPromotion FROM Promotion;
SELECT COUNT(*) AS NoOfPackage_Item FROM Package_Item;
SELECT COUNT(*) AS NoOfOrders FROM Orders;
SELECT COUNT(*) AS NoOfOrder_Item FROM Order_Item;
SELECT COUNT(*) AS NoOfOrder_Package FROM Order_Package;
SELECT COUNT(*) AS NoOfPayment FROM Payment;
SELECT COUNT(*) AS NoOfAddress FROM Address;
SELECT COUNT(*) AS NoOfShipment FROM Shipment;
