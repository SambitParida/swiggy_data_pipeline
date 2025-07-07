use role sysadmin;
use database sandbox;
USE WAREHOUSE compute_wh;

create or replace stream clean_sch.restaurant_location_stm
on table clean_sch.restaurant_location
comment = 'this is the standard stream object on restaurant_location table to track inserts, updates and deletes';