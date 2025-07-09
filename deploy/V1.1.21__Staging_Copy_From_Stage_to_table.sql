use role sysadmin;
use database sandbox;
USE WAREHOUSE data_load_wh;

/*Copy Data from named internal stage  to staging table */

copy into stage_sch.restaurant 
    (restaurantid,      
    name,  cuisinetype,    pricing_for_2,    restaurant_phone,    operatinghours,    locationid,    activeflag,    openstatus,
    locality,    restaurant_address,    latitude,    longitude,    createddate,    modifieddate,     stg_file_name,    stg_file_load_ts,
    stg_file_md5,    copy_data_ts 
    )
from (
select 
    t.$1::text as restaurantid,
    t.$2::text as name,
    t.$3::text as cuisinetype,
    t.$4::text as pricing_for_2,
    t.$5::text as restaurant_phone,
    t.$6::text as operatinghours,
    t.$7::text as locationid,
    t.$8::text as activeflag,
    t.$9::text as openstatus,
    t.$10::text as locality,
    t.$11::text as restaurant_address,
    t.$12::text as latitude,
    t.$13::text as longitude,
    t.$14::text as createddate,
    t.$15::text as modifieddate,
    metadata$filename as stg_file_name,
    metadata$file_last_modified as stg_file_load_ts,
    metadata$file_content_key as stg_file_md5,
    current_timestamp as copy_data_ts    
 from @stage_sch.csv_stg/initial/restaurant t)
 file_format = (format_name = 'stage_sch.csv_file_format') 
on_error = abort_statement;

copy into stage_sch.customer 
    (  customerid ,
    name, 
    mobile ,
    email ,
    loginbyusing ,
    gender ,
    dob ,
    anniversary,
    preferences ,
    createddate ,
    modifieddate ,    stg_file_name,    stg_file_load_ts,
    stg_file_md5,    copy_data_ts 
    )
from (
select 
    t.$1::text as customerid,
    t.$2::text as name,
    t.$3::text as mobile,
    t.$4::text as email,
    t.$5::text as loginbyusing,
    t.$6::text as gender,
    t.$7::text as dob,
    t.$8::text as anniversary,
    t.$9::text as preferences,
    t.$10::text as createddate,
    t.$11::text as modifieddate,
    metadata$filename as stg_file_name,
    metadata$file_last_modified as stg_file_load_ts,
    metadata$file_content_key as stg_file_md5,
    current_timestamp as copy_data_ts    
 from @stage_sch.csv_stg/initial/customers t)
 file_format = (format_name = 'stage_sch.csv_file_format') 
on_error = abort_statement;

copy into stage_sch.customeraddress (addressid, customerid, flatno, houseno, floor, building, 
                               landmark, locality,city,pincode, state, coordinates, primaryflag, addresstype, 
                               createddate, modifieddate, 
                               stg_file_name, stg_file_load_ts, stg_file_md5, copy_data_ts)
from (
    select 
        t.$1::text as addressid,
        t.$2::text as customerid,
        t.$3::text as flatno,
        t.$4::text as houseno,
        t.$5::text as floor,
        t.$6::text as building,
        t.$7::text as landmark,
        t.$8::text as locality,
        t.$9::text as city,
        t.$10::text as State,
        t.$11::text as Pincode,
        t.$12::text as coordinates,
        t.$13::text as primaryflag,
        t.$14::text as addresstype,
        t.$15::text as createddate,
        t.$16::text as modifieddate,
        metadata$filename as stg_file_name,
        metadata$file_last_modified as stg_file_load_ts,
        metadata$file_content_key as stg_file_md5,
        current_timestamp as copy_data_ts
    from @stage_sch.csv_stg/initial/customer_address t
)
file_format = (format_name = 'stage_sch.csv_file_format')
on_error = abort_statement;

copy into stage_sch.menu (menuid, restaurantid, itemname, description, price, category, 
                availability, itemtype, createddate, modifieddate,
                stg_file_name, stg_file_load_ts, stg_file_md5, copy_data_ts)
from (
    select 
        t.$1::text as menuid,
        t.$2::text as restaurantid,
        t.$3::text as itemname,
        t.$4::text as description,
        t.$5::text as price,
        t.$6::text as category,
        t.$7::text as availability,
        t.$8::text as itemtype,
        t.$9::text as createddate,
        t.$10::text as modifieddate,
        metadata$filename as stg_file_name,
        metadata$file_last_modified as stg_file_load_ts,
        metadata$file_content_key as stg_file_md5,
        current_timestamp as copy_data_ts
    from @stage_sch.csv_stg/initial/menu t
)
file_format = (format_name = 'stage_sch.csv_file_format')
on_error = abort_statement;

copy into stage_sch.deliveryagent (deliveryagentid, name, phone, vehicletype, locationid, 
                         status, gender, rating, createddate, modifieddate,
                         stg_file_name, stg_file_load_ts, stg_file_md5, copy_data_ts)
from (
    select 
        t.$1::text as deliveryagentid,
        t.$2::text as name,
        t.$3::text as phone,
        t.$4::text as vehicletype,
        t.$5::text as locationid,
        t.$6::text as status,
        t.$7::text as gender,
        t.$8::text as rating,
        t.$9::text as createddate,
        t.$10::text as modifieddate,
        metadata$filename as stg_file_name,
        metadata$file_last_modified as stg_file_load_ts,
        metadata$file_content_key as stg_file_md5,
        current_timestamp as copy_data_ts
    from @stage_sch.csv_stg/initial/delivery_agent t
)
file_format = (format_name = 'stage_sch.csv_file_format')
on_error = abort_statement;

copy into stage_sch.delivery (deliveryid,orderid, deliveryagentid, deliverystatus, 
                    estimatedtime, addressid, deliverydate, createddate, 
                    modifieddate, stg_file_name, stg_file_load_ts, 
                    stg_file_md5, copy_data_ts)
from (
    select 
        t.$1::text as deliveryid,
        t.$2::text as orderid,
        t.$3::text as deliveryagentid,
        t.$4::text as deliverystatus,
        t.$5::text as estimatedtime,
        t.$6::text as addressid,
        t.$7::text as deliverydate,
        t.$8::text as createddate,
        t.$9::text as modifieddate,
        metadata$filename as stg_file_name,
        metadata$file_last_modified as stg_file_load_ts,
        metadata$file_content_key as stg_file_md5,
        current_timestamp as copy_data_ts
    from @stage_sch.csv_stg/initial/delivery/ t
)
file_format = (format_name = 'stage_sch.csv_file_format')
on_error = abort_statement;

copy into stage_sch.orders (orderid, customerid, restaurantid, orderdate, totalamount, 
                  status, paymentmethod, createddate, modifieddate,
                  stg_file_name, stg_file_load_ts, stg_file_md5, copy_data_ts)
from (
    select 
        t.$1::text as orderid,
        t.$2::text as customerid,
        t.$3::text as restaurantid,
        t.$4::text as orderdate,
        t.$5::text as totalamount,
        t.$6::text as status,
        t.$7::text as paymentmethod,
        t.$8::text as createddate,
        t.$9::text as modifieddate,
        metadata$filename as stg_file_name,
        metadata$file_last_modified as stg_file_load_ts,
        metadata$file_content_key as stg_file_md5,
        current_timestamp as copy_data_ts
    from @stage_sch.csv_stg/initial/order/ t
)
file_format = (format_name = 'stage_sch.csv_file_format')
on_error = abort_statement;


copy into stage_sch.orderitem (orderitemid, orderid, menuid, quantity, price, 
                     subtotal, createddate, modifieddate,
                     stg_file_name, stg_file_load_ts, stg_file_md5, copy_data_ts)
from (
    select 
        t.$1::text as orderitemid,
        t.$2::text as orderid,
        t.$3::text as menuid,
        t.$4::text as quantity,
        t.$5::text as price,
        t.$6::text as subtotal,
        t.$7::text as createddate,
        t.$8::text as modifieddate,
        metadata$filename as stg_file_name,
        metadata$file_last_modified as stg_file_load_ts,
        metadata$file_content_key as stg_file_md5,
        current_timestamp as copy_data_ts
    from @stage_sch.csv_stg/initial/order_item/ t
)
file_format = (format_name = 'stage_sch.csv_file_format')
on_error = abort_statement;