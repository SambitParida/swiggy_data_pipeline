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
