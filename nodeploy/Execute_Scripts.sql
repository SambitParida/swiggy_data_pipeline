use role sysadmin;
use database sandbox;
USE WAREHOUSE compute_wh;

copy into stage_sch.location (locationid, city, state, zipcode, activeflag, 
                    createddate, modifieddate, stg_file_name, 
                    stg_file_load_ts, stg_file_md5, copy_data_ts)
from (
    select 
        t.$1::text as locationid,
        t.$2::text as city,
        t.$3::text as state,
        t.$4::text as zipcode,
        t.$5::text as activeflag,
        t.$6::text as createddate,
        t.$7::text as modifieddate,
        metadata$filename as stg_file_name,
        metadata$file_last_modified as stg_file_load_ts,
        metadata$file_content_key as stg_file_md5,
        current_timestamp as copy_data_ts
    from @"SANDBOX"."STAGE_SCH"."CSV_STG"/delta/location/delta-day03-invalid-delimiter.csv.gz t
)
file_format = (format_name = 'stage_sch.csv_file_format')
on_error = abort_statement;


--Cleaning Bad Data from stage table and making the stream clean --
create table stage_sch.temp_stream as select * from stage_sch.location_stm;
delete from stage_sch.location where locationid like '%|%';

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
    from @stage_sch.csv_stg/initial/order_item/
 (file_format =>  'stage_sch.csv_file_format') t;

 list @stage_sch.csv_stg/initial/delivery

CREATE OR REPLACE WAREHOUSE data_load_wh WAREHOUSE_SIZE=LARGE INITIALLY_SUSPENDED=TRUE;
select current_role()
use role accountadmin
grant usage on warehouse compute_wh to public;



SELECT * FROM       CONCAT(
                    SOURCE.ADDRESS_ID,
                    SOURCE.CUSTOMER_ID_FK,
                    SOURCE.FLAT_NO,
                    SOURCE.HOUSE_NO,
                    SOURCE.FLOOR,
                    SOURCE.BUILDING,
                    SOURCE.LANDMARK,
                    SOURCE.LOCALITY,
                    SOURCE.CITY,
                    SOURCE.STATE,
                    SOURCE.PINCODE,
                    SOURCE.COORDINATES,
                    SOURCE.PRIMARY_FLAG,
                    SOURCE.ADDRESS_TYPE
                ) AS A ,
        SOURCE.ADDRESS_ID,
        SOURCE.CUSTOMER_ID_FK,
        SOURCE.FLAT_NO,
        SOURCE.HOUSE_NO,
        SOURCE.FLOOR,
        SOURCE.BUILDING,
        SOURCE.LANDMARK,
        SOURCE.LOCALITY,
        SOURCE.CITY,
        SOURCE.STATE,
        SOURCE.PINCODE,
        SOURCE.COORDINATES,
        SOURCE.PRIMARY_FLAG,
        SOURCE.ADDRESS_TYPE,
        CURRENT_TIMESTAMP(),
        NULL,
        TRUE FROM CLEAN_SCH.CUSTOMERADDRESS_STM SOURCE;


---------------------

use role accountadmin;
use role sysadmin;
use role public;

use role useradmin;
use database sandbox;
select * from STAGE_SCH.CUSTOMER;

grant usage on database sandbox to public;
grant usage on schema stage_sch to public;
grant select on STAGE_SCH.CUSTOMER to public;

use schema stage_sch;
show masking policies;