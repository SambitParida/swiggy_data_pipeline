use role sysadmin;
use database sandbox;
use schema consumption_sch;
USE WAREHOUSE compute_wh;

CREATE OR REPLACE TABLE CONSUMPTION_SCH.RESTAURANT_DIM (
    RESTAURANT_HK NUMBER primary key,                   -- Hash key for the restaurant location
    RESTAURANT_ID NUMBER,                   -- Restaurant ID without auto-increment
    NAME STRING(100),                       -- Restaurant name
    CUISINE_TYPE STRING,                    -- Type of cuisine offered
    PRICING_FOR_TWO NUMBER(10, 2),          -- Pricing for two people
    RESTAURANT_PHONE STRING(15) WITH TAG (common.pii_policy_tag = 'SENSITIVE'),            -- Restaurant phone number
    OPERATING_HOURS STRING(100),            -- Restaurant operating hours
    LOCATION_ID_FK NUMBER,                  -- Foreign key reference to location
    ACTIVE_FLAG STRING(10),                 -- Indicates if the restaurant is active
    OPEN_STATUS STRING(10),                 -- Indicates if the restaurant is currently open
    LOCALITY STRING(100),                   -- Locality of the restaurant
    RESTAURANT_ADDRESS STRING,              -- Full address of the restaurant
    LATITUDE NUMBER(9, 6),                  -- Latitude for the restaurant's location
    LONGITUDE NUMBER(9, 6),                 -- Longitude for the restaurant's location
    EFF_START_DATE TIMESTAMP_TZ,            -- Effective start date for the record
    EFF_END_DATE TIMESTAMP_TZ,              -- Effective end date for the record (NULL if active)
    IS_CURRENT BOOLEAN                     -- Indicates whether the record is the current version
);

CREATE OR REPLACE TABLE CONSUMPTION_SCH.CUSTOMER_DIM (
    CUSTOMER_HK NUMBER PRIMARY KEY,               -- Surrogate key for the customer
    CUSTOMER_ID STRING NOT NULL,                                 -- Natural key for the customer
    NAME STRING(100) NOT NULL,                                   -- Customer name
    MOBILE STRING(15) WITH TAG (common.pii_policy_tag = 'PII'),                                           -- Mobile number
    EMAIL STRING(100) WITH TAG (common.pii_policy_tag = 'EMAIL'),                                           -- Email
    LOGIN_BY_USING STRING(50),                                   -- Method of login
    GENDER STRING(10) WITH TAG (common.pii_policy_tag = 'PII'),                                           -- Gender
    DOB DATE WITH TAG (common.pii_policy_tag = 'PII'),                                                    -- Date of birth
    ANNIVERSARY DATE,                                            -- Anniversary
    PREFERENCES STRING,                                          -- Preferences
    EFF_START_DATE TIMESTAMP_TZ,                                 -- Effective start date
    EFF_END_DATE TIMESTAMP_TZ,                                   -- Effective end date (NULL if active)
    IS_CURRENT BOOLEAN                                           -- Flag to indicate the current record
);

CREATE OR REPLACE TABLE CONSUMPTION_SCH.CUSTOMER_ADDRESS_DIM (
    CUSTOMER_ADDRESS_HK NUMBER PRIMARY KEY comment 'Customer Address HK (EDW)',        -- Surrogate key (hash key)
    ADDRESS_ID INT comment 'Primary Key (Source System)',                                -- Original primary key
    CUSTOMER_ID_FK STRING comment 'Customer FK (Source System)',                            -- Surrogate key from Customer Dimension (Foreign Key)
    FLAT_NO STRING,                                -- Flat number
    HOUSE_NO STRING,                               -- House number
    FLOOR STRING,                                  -- Floor
    BUILDING STRING,                               -- Building name
    LANDMARK STRING,                               -- Landmark
    LOCALITY STRING,                               -- Locality
    CITY STRING,                                   -- City
    STATE STRING,                                  -- State
    PINCODE STRING,                                -- Pincode
    COORDINATES STRING,                            -- Geo-coordinates
    PRIMARY_FLAG STRING,                           -- Whether it's the primary address
    ADDRESS_TYPE STRING,                           -- Type of address (e.g., Home, Office)

    -- SCD2 Columns
    EFF_START_DATE TIMESTAMP_TZ,                                 -- Effective start date
    EFF_END_DATE TIMESTAMP_TZ,                                   -- Effective end date (NULL if active)
    IS_CURRENT BOOLEAN                                           -- Flag to indicate the current record
);

CREATE OR REPLACE TABLE consumption_sch.menu_dim (
    Menu_Dim_HK NUMBER primary key comment 'Menu Dim HK (EDW)',                         -- Hash key generated for Menu Dim table
    Menu_ID INT NOT NULL comment 'Primary Key (Source System)',                       -- Unique and non-null Menu_ID
    Restaurant_ID_FK INT NOT NULL comment 'Restaurant FK (Source System)',                          -- Identifier for the restaurant
    Item_Name STRING,                            -- Name of the menu item
    Description STRING,                         -- Description of the menu item
    Price DECIMAL(10, 2),                       -- Price as a numeric value with 2 decimal places
    Category STRING,                            -- Food category (e.g., North Indian)
    Availability BOOLEAN,                       -- Availability status (True/False)
    Item_Type STRING,                           -- Dietary classification (e.g., Vegan)
    EFF_START_DATE TIMESTAMP_NTZ,               -- Effective start date of the record
    EFF_END_DATE TIMESTAMP_NTZ,                 -- Effective end date of the record
    IS_CURRENT BOOLEAN                         -- Flag to indicate if the record is current (True/False)
);

CREATE OR REPLACE TABLE consumption_sch.delivery_agent_dim (
    delivery_agent_hk number primary key comment 'Delivery Agend Dim HK (EDW)',               -- Hash key for unique identification
    delivery_agent_id NUMBER not null comment 'Primary Key (Source System)',               -- Business key
    name STRING NOT NULL,                   -- Delivery agent name
    phone STRING UNIQUE,                    -- Phone number, unique
    vehicle_type STRING,                    -- Type of vehicle
    location_id_fk NUMBER NOT NULL comment 'Location FK (Source System)',                     -- Location ID
    status STRING,                          -- Current status of the delivery agent
    gender STRING,                          -- Gender
    rating NUMBER(4,2),                     -- Rating with one decimal precision
    eff_start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Effective start date
    eff_end_date TIMESTAMP,                 -- Effective end date (NULL for active record)
    is_current BOOLEAN DEFAULT TRUE
);

CREATE OR REPLACE TABLE CONSUMPTION_SCH.DATE_DIM (
    DATE_DIM_HK NUMBER PRIMARY KEY comment 'Menu Dim HK (EDW)',   -- Surrogate key for date dimension
    CALENDAR_DATE DATE UNIQUE,                     -- The actual calendar date
    YEAR NUMBER,                                   -- Year
    QUARTER NUMBER,                                -- Quarter (1-4)
    MONTH NUMBER,                                  -- Month (1-12)
    WEEK NUMBER,                                   -- Week of the year
    DAY_OF_YEAR NUMBER,                            -- Day of the year (1-365/366)
    DAY_OF_WEEK NUMBER,                            -- Day of the week (1-7)
    DAY_OF_THE_MONTH NUMBER,                       -- Day of the month (1-31)
    DAY_NAME STRING                                -- Name of the day (e.g., Monday)
)
comment = 'Date dimension table created using min of order data.';

CREATE OR REPLACE TABLE consumption_sch.order_item_fact (
    order_item_fact_sk NUMBER AUTOINCREMENT comment 'Surrogate Key (EDW)', -- Surrogate key for the fact table
    order_item_id NUMBER  comment 'Order Item FK (Source System)',                    -- Natural key from the source data
    order_id NUMBER  comment 'Order FK (Source System)',                         -- Reference to the order dimension
    customer_dim_key NUMBER  comment 'Order FK (Source System)',                      -- Reference to the customer dimension
    customer_address_dim_key NUMBER,                      -- Reference to the customer dimension
    restaurant_dim_key NUMBER,                    -- Reference to the restaurant dimension
    restaurant_location_dim_key NUMBER,                    -- Reference to the restaurant dimension
    menu_dim_key NUMBER,                          -- Reference to the menu dimension
    delivery_agent_dim_key NUMBER,                -- Reference to the delivery agent dimension
    order_date_dim_key NUMBER,                         -- Reference to the date dimension
    quantity NUMBER,                          -- Measure
    price NUMBER(10, 2),                            -- Measure
    subtotal NUMBER(10, 2),                         -- Measure
    delivery_status VARCHAR,                        -- Delivery information
    estimated_time VARCHAR                          -- Delivery information
);

