use role sysadmin;
use database sandbox;
use schema stage_sch;
USE WAREHOUSE compute_wh;

--- Stream object to capture the changes in clean_sch.restaurant table. 
create or replace stream clean_sch.restaurant_stm 
on table clean_sch.restaurant
comment = 'This is a standard stream object on the clean restaurant table to track insert, update, and delete changes';

create or replace stream clean_sch.customer_stm 
on table clean_sch.customer
comment = 'This is a standard stream object on the clean customer table to track insert, update, and delete changes';

create or replace stream clean_sch.customeraddress_stm 
on table clean_sch.customeraddress
comment = 'This is a standard stream object on the clean customeraddress table to track insert, update, and delete changes';

create or replace stream clean_sch.menu_stm 
on table clean_sch.menu
comment = 'This is a standard stream object on the clean menu table to track insert, update, and delete changes';

create or replace stream clean_sch.deliveryagent_stm 
on table clean_sch.deliveryagent
comment = 'This is a standard stream object on the clean deliveryagent table to track insert, update, and delete changes';

create or replace stream clean_sch.delivery_stm 
on table clean_sch.delivery
comment = 'This is a standard stream object on the clean delivery table to track insert, update, and delete changes';

create or replace stream clean_sch.orders_stm 
on table clean_sch.orders
comment = 'This is a standard stream object on the clean orders table to track insert, update, and delete changes';

create or replace stream clean_sch.orderitem_stm 
on table clean_sch.orderitem
comment = 'This is a standard stream object on the clean orderitem table to track insert, update, and delete changes';

