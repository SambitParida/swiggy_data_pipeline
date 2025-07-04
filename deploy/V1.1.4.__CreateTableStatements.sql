use role sysadmin;
use database sandbox;
USE WAREHOUSE compute_wh;
create or replace table STAGE_SCH.location(
    locationid text,
    city text,
    state text,
    zipcode text,
    activeflag text,
    createddate text,
    modifieddate text,
    -- below are audit columns --
    _stg_file_name text,
    _stg_file_load_ts timestamp,
    _stg_file_mdg text,
    _copy_data_ts timestamp default current_timestamp
    );
    --comment = 'This is the location stage/raw where data will be copied from internal stage using copy command. This is as-is data representation from the source location.
    --All column are text datatype except the audit columns';