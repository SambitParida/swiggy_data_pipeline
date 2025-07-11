use database sandbox;
use schema stage_sch;

-- Initial Load --

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/01-location-csv/01.01-initial-load/location-5rows.csv @CSV_STG/initial/location;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/02-restaurant-csv/02.01-initial-load/restaurant-delhi+NCR.csv @CSV_STG/initial/restaurant;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/03-customer-csv/03.01-initial-load/customers-initial.csv @CSV_STG/initial/customers;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/04-customer-address-csv/04.01-initial-load/* @CSV_STG/initial/customer_address;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/05-login-audit/05.01-initial-load/* @CSV_STG/initial/login_audit;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/06-menu/06.01-initial-load/* @CSV_STG/initial/menu;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/07-order-csv/07.01-initial-load/* @CSV_STG/initial/order;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/08-order-item-csv/08.01-initial-load/* @CSV_STG/initial/order_item;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/09-delivery-agent/09.01-initial-load/* @CSV_STG/initial/delivery_agent;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/10-delivery-csv/10.01-initial-load/* @CSV_STG/initial/delivery;


-- Delta Load --

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/01-location-csv/01.02-delta-load/* @CSV_STG/delta/location;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/02-restaurant-csv/02.02-delta-load/day-01-insert-restaurant-delhi+NCR.csv @CSV_STG/delta/restaurant;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/02-restaurant-csv/02.02-delta-load/day-02-upsert-restaurant-delhi+NCR.csv @CSV_STG/delta/restaurant;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/03-customer-csv/03.02-delta-load/* @CSV_STG/delta/customers;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/04-customer-address-csv/04.02-delta-load/* @CSV_STG/delta/customer_address;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/05-login-audit/05.02-delta-load/* @CSV_STG/delta/login_audit;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/06-menu/06.02-delta-load/* @CSV_STG/delta/menu;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/07-order-csv/07.02-delta-load/* @CSV_STG/delta/order;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/08-order-item-csv/08.02-delta-load/* @CSV_STG/delta/order_item;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/09-delivery-agent/09.02-delta-load/* @CSV_STG/delta/delivery_agent;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/10-delivery-csv/10.02-delta-load/* @CSV_STG/delta/delivery;

LIST @STAGE_SCH.CSV_STG/initial;

select 
    t.$1::text as locationid,
    t.$2::text as city,
    t.$3::text as state,
    t.$4::text as zipcode,
    t.$5::text as activeflag,
    t.$6::text as createddate,
    t.$7::text as modifieddate    
 from @stage_sch.csv_stg/initial/location
 (file_format => 'stage_sch.csv_file_format') t


