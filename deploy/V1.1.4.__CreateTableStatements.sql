use role sysadmin;
use database sandbox;
USE WAREHOUSE compute_wh;
create or replace table stage_sch.location(
    locationid text,
    city text,
    state text,
    zipcode text,
    activeflag text,
    createddate text,
    modifieddate text,
    stg_file_name text,
    stg_file_load_ts timestamp,
    stg_file_mdg text,
    copy_data_ts timestamp default current_timestamp
    );