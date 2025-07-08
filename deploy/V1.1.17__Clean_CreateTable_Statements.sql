use role sysadmin;
use database sandbox;
use schema stage_sch;
USE WAREHOUSE compute_wh;

-- the restaurant table where data types are defined. 
create or replace table clean_sch.restaurant (
    restaurant_sk number autoincrement primary key,              -- primary key with auto-increment
    restaurant_id number unique,                                        -- restaurant id without auto-increment
    name string(100) not null,                                   -- restaurant name, required field
    cuisine_type string,                                         -- type of cuisine offered
    pricing_for_two number(10, 2),                               -- pricing for two people, up to 10 digits with 2 decimal places
    restaurant_phone string(15) WITH TAG (common.pii_policy_tag = 'SENSITIVE'),                                 -- phone number, supports 10-digit or international format
    operating_hours string(100),                                  -- restaurant operating hours
    location_id_fk number,                                       -- reference id for location, defaulted to 1
    active_flag string(10),                                      -- indicates if the restaurant is active
    open_status string(10),                                      -- indicates if the restaurant is currently open
    locality string(100),                                        -- locality of the restaurant
    restaurant_address string,                                   -- address of the restaurant, supports longer text
    latitude number(9, 6),                                       -- latitude with 6 decimal places for precision
    longitude number(9, 6),                                      -- longitude with 6 decimal places for precision
    created_dt timestamp_tz,                                     -- record creation date
    modified_dt timestamp_tz,                                    -- last modified date, allows null if not modified

    -- additional audit columns
    stg_file_name string,                                       -- file name for audit
    stg_file_load_ts timestamp_ntz,                             -- file load timestamp for audit
    stg_file_md5 string,                                        -- md5 hash for file content for audit
    copy_data_ts timestamp_ntz default current_timestamp        -- timestamp when data is copied, defaults to current timestamp
);

CREATE OR REPLACE TABLE CLEAN_SCH.CUSTOMER (
    
    CUSTOMER_SK NUMBER AUTOINCREMENT PRIMARY KEY,                -- Auto-incremented primary key
    CUSTOMER_ID STRING NOT NULL,                                 -- Customer ID
    NAME STRING(100) NOT NULL,                                   -- Customer name
    MOBILE STRING(15)  WITH TAG (common.pii_policy_tag = 'PII'),                                           -- Mobile number, accommodating international format
    EMAIL STRING(100) WITH TAG (common.pii_policy_tag = 'EMAIL'),                                           -- Email
    LOGIN_BY_USING STRING(50),                                   -- Method of login (e.g., Social, Google, etc.)
    GENDER STRING(10)  WITH TAG (common.pii_policy_tag = 'PII'),                                           -- Gender
    DOB DATE WITH TAG (common.pii_policy_tag = 'PII'),                                                    -- Date of birth in DATE format
    ANNIVERSARY DATE,                                            -- Anniversary in DATE format
    PREFERENCES STRING,                                          -- Customer preferences
    CREATED_DT TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP,           -- Record creation timestamp
    MODIFIED_DT TIMESTAMP_TZ,                                    -- Record modification timestamp, allows NULL if not modified

    -- Additional audit columns
    stg_file_name STRING,                                       -- File name for audit
    stg_file_load_ts TIMESTAMP_NTZ,                             -- File load timestamp
    stg_file_md5 STRING,                                        -- MD5 hash for file content
    copy_data_ts TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP        -- Copy data timestamp
);

CREATE OR REPLACE TABLE CLEAN_SCH.CUSTOMER_ADDRESS (
    CUSTOMER_ADDRESS_SK NUMBER AUTOINCREMENT PRIMARY KEY comment 'Surrogate Key (EWH)',                -- Auto-incremented primary key
    ADDRESS_ID INT comment 'Primary Key (Source Data)',                 -- Primary key as string
    CUSTOMER_ID_FK INT comment 'Customer FK (Source Data)',                -- Foreign key reference as string (no constraint in Snowflake)
    FLAT_NO STRING,                    -- Flat number as string
    HOUSE_NO STRING,                   -- House number as string
    FLOOR STRING,                      -- Floor as string
    BUILDING STRING,                   -- Building name as string
    LANDMARK STRING,                   -- Landmark as string
    locality STRING,                   -- locality as string
    CITY STRING,                       -- City as string
    STATE STRING,                      -- State as string
    PINCODE STRING,                    -- Pincode as string
    COORDINATES STRING,                -- Coordinates as string
    PRIMARY_FLAG STRING,               -- Primary flag as string
    ADDRESS_TYPE STRING,               -- Address type as string
    CREATED_DATE TIMESTAMP_TZ,         -- Created date as timestamp with time zone
    MODIFIED_DATE TIMESTAMP_TZ,        -- Modified date as timestamp with time zone

    -- Audit columns with appropriate data types
    stg_file_name STRING,
    stg_file_load_ts TIMESTAMP,
    stg_file_md5 STRING,
    copy_data_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE TABLE clean_sch.menu (
    Menu_SK INT AUTOINCREMENT PRIMARY KEY comment 'Surrogate Key (EDW)',  -- Auto-incrementing primary key for internal tracking
    Menu_ID INT NOT NULL UNIQUE comment 'Primary Key (Source System)' ,             -- Unique and non-null Menu_ID
    Restaurant_ID_FK INT comment 'Restaurant FK(Source System)' ,                      -- Identifier for the restaurant
    Item_Name STRING not null,                        -- Name of the menu item
    Description STRING not null,                     -- Description of the menu item
    Price DECIMAL(10, 2) not null,                   -- Price as a numeric value with 2 decimal places
    Category STRING,                        -- Food category (e.g., North Indian)
    Availability BOOLEAN,                   -- Availability status (True/False)
    Item_Type STRING,                        -- Dietary classification (e.g., Vegan)
    Created_dt TIMESTAMP_NTZ,               -- Date when the record was created
    Modified_dt TIMESTAMP_NTZ,              -- Date when the record was last modified

    -- Audit columns for traceability
    stg_file_name STRING,                  -- Source file name
    stg_file_load_ts TIMESTAMP_NTZ,        -- Timestamp when data was loaded from the staging layer
    stg_file_md5 STRING,                   -- MD5 hash of the source file
    copy_data_ts TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP -- Timestamp when data was copied to the clean layer
);

CREATE OR REPLACE TABLE clean_sch.delivery_agent (
    delivery_agent_sk INT AUTOINCREMENT PRIMARY KEY comment 'Surrogate Key (EDW)', -- Primary key with auto-increment
    delivery_agent_id INT NOT NULL UNIQUE comment 'Primary Key (Source System)',               -- Delivery agent ID as integer
    name STRING NOT NULL,                -- Name as string, required field
    phone STRING NOT NULL,                 -- Phone as string, unique constraint
    vehicle_type STRING NOT NULL,                 -- Vehicle type as string
    location_id_fk INT comment 'Location FK(Source System)',                     -- Location ID as integer
    status STRING,                       -- Status as string
    gender STRING,                       -- Gender as string
    rating number(4,2),                        -- Rating as float
    created_dt TIMESTAMP_NTZ,          -- Created date as timestamp without timezone
    modified_dt TIMESTAMP_NTZ,         -- Modified date as timestamp without timezone

    -- Audit columns with appropriate data types
    stg_file_name STRING,               -- Staging file name as string
    stg_file_load_ts TIMESTAMP,         -- Staging file load timestamp
    stg_file_md5 STRING,                -- Staging file MD5 hash as string
    copy_data_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Data copy timestamp with default value
);

CREATE OR REPLACE TABLE clean_sch.delivery (
    delivery_sk INT AUTOINCREMENT PRIMARY KEY comment 'Surrogate Key (EDW)', -- Primary key with auto-increment
    delivery_id INT NOT NULL comment 'Primary Key (Source System)',
    order_id_fk NUMBER NOT NULL comment 'Order FK (Source System)',                        -- Foreign key reference, converted to numeric type
    delivery_agent_id_fk NUMBER NOT NULL comment 'Delivery Agent FK (Source System)',               -- Foreign key reference, converted to numeric type
    delivery_status STRING,                 -- Delivery status, stored as a string
    estimated_time STRING,                  -- Estimated time, stored as a string
    customer_address_id_fk NUMBER NOT NULL  comment 'Customer Address FK (Source System)',                      -- Foreign key reference, converted to numeric type
    delivery_date TIMESTAMP,                -- Delivery date, converted to timestamp
    created_date TIMESTAMP,                 -- Created date, converted to timestamp
    modified_date TIMESTAMP,                -- Modified date, converted to timestamp

    -- Audit columns with appropriate data types
    stg_file_name STRING,                  -- Source file name
    stg_file_load_ts TIMESTAMP,            -- Source file load timestamp
    stg_file_md5 STRING,                   -- MD5 checksum of the source file
    copy_data_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Metadata timestamp
);

CREATE OR REPLACE TABLE CLEAN_SCH.ORDERS (
    ORDER_SK NUMBER AUTOINCREMENT PRIMARY KEY comment 'Surrogate Key (EDW)',                -- Auto-incremented primary key
    ORDER_ID BIGINT UNIQUE comment 'Primary Key (Source System)',                      -- Primary key inferred as BIGINT
    CUSTOMER_ID_FK BIGINT comment 'Customer FK(Source System)',                   -- Foreign key inferred as BIGINT
    RESTAURANT_ID_FK BIGINT comment 'Restaurant FK(Source System)',                 -- Foreign key inferred as BIGINT
    ORDER_DATE TIMESTAMP,                 -- Order date inferred as TIMESTAMP
    TOTAL_AMOUNT DECIMAL(10, 2),          -- Total amount inferred as DECIMAL with two decimal places
    STATUS STRING,                        -- Status as STRING
    PAYMENT_METHOD STRING,                -- Payment method as STRING
    created_dt timestamp_tz,                                     -- record creation date
    modified_dt timestamp_tz,                                    -- last modified date, allows null if not modified

    -- additional audit columns
    stg_file_name string,                                       -- file name for audit
    stg_file_load_ts timestamp_ntz,                             -- file load timestamp for audit
    stg_file_md5 string,                                        -- md5 hash for file content for audit
    copy_data_ts timestamp_ntz default current_timestamp        -- timestamp when data is copied, defaults to current timestamp
);

CREATE OR REPLACE TABLE clean_sch.order_item (
    order_item_sk NUMBER AUTOINCREMENT primary key comment 'Surrogate Key (EDW)',    -- Auto-incremented unique identifier for each order item
    order_item_id NUMBER  NOT NULL UNIQUE comment 'Primary Key (Source System)',
    order_id_fk NUMBER  NOT NULL comment 'Order FK(Source System)',                  -- Foreign key reference for Order ID
    menu_id_fk NUMBER  NOT NULL comment 'Menu FK(Source System)',                   -- Foreign key reference for Menu ID
    quantity NUMBER(10, 2),                 -- Quantity as a decimal number
    price NUMBER(10, 2),                    -- Price as a decimal number
    subtotal NUMBER(10, 2),                 -- Subtotal as a decimal number
    created_dt TIMESTAMP,                 -- Created date of the order item
    modified_dt TIMESTAMP,                -- Modified date of the order item

    -- Audit columns
    stg_file_name VARCHAR(255),            -- File name of the staging file
    stg_file_load_ts TIMESTAMP,            -- Timestamp when the file was loaded
    stg_file_md5 VARCHAR(255),             -- MD5 hash of the file for integrity check
    copy_data_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp when data is copied into the clean layer
);
