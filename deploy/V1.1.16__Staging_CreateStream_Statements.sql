use role sysadmin;
use database sandbox;
use schema stage_sch;
USE WAREHOUSE compute_wh;

--- Stream object to capture the changes in restaurant table. 
create or replace stream stage_sch.restaurant_stm 
on table stage_sch.restaurant
append_only = true
comment = 'This is the append-only stream object on restaurant table that only gets delta data';

-- Stream object to capture the changes in customer table. 
create or replace stream stage_sch.customer_stm 
on table stage_sch.customer
append_only = true
comment = 'This is the append-only stream object on customer table that only gets delta data';

-- Stream object to capture the changes in customer table. 
create or replace stream stage_sch.customeraddress_stm 
on table stage_sch.customeraddress
append_only = true
comment = 'This is the append-only stream object on customeraddress table that only gets delta data';

-- Stream object to capture the changes in menu table. 
create or replace stream stage_sch.menu_stm 
on table stage_sch.menu
append_only = true
comment = 'This is the append-only stream object on menu table that only gets delta data';

-- Stream object to capture the changes in menu table. 
create or replace stream stage_sch.deliveryagent_stm 
on table stage_sch.deliveryagent
append_only = true
comment = 'This is the append-only stream object on deliveryagent table that only gets delta data';

-- Stream object to capture the changes in delivery table. 
create or replace stream stage_sch.delivery_stm 
on table stage_sch.delivery
append_only = true
comment = 'This is the append-only stream object on delivery table that only gets delta data';

-- Stream object to capture the changes in orders table. 
create or replace stream stage_sch.orders_stm 
on table stage_sch.orders
append_only = true
comment = 'This is the append-only stream object on orders table that only gets delta data';

-- Stream object to capture the changes in orders table. 
create or replace stream stage_sch.orderitem_stm 
on table stage_sch.orderitem
append_only = true
comment = 'This is the append-only stream object on orderitem table that only gets delta data';
