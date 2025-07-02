use database sandbox;
use schema stage_sch;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/02-restaurant-csv/02.01-initial-load/restaurant-delhi+NCR.csv @CSV_STG/initial/restaurant;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/02-restaurant-csv/02.02-delta-load/day-01-insert-restaurant-delhi+NCR.csv @CSV_STG/delta/restaurant;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/02-restaurant-csv/02.02-delta-load/day-02-upsert-restaurant-delhi+NCR.csv @CSV_STG/delta/restaurant;

PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/03-customer-csv/03.01-initial-load/customers-initial.csv @CSV_STG/initial/customers;
PUT file:///Users/sambitparida/Desktop/Sambit/Learning/SnowflakePractice/Swiggy_Order_Data/03-customer-csv/03.02-delta-load/* @CSV_STG/delta/customers;
