use role sysadmin;
use database sandbox;
USE WAREHOUSE compute_wh;

/*Create tables in schema stage_sch */
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
    stg_file_md5 text,
    copy_data_ts timestamp default current_timestamp);

/*Create tables in schema stage_sch */
create or replace table clean_sch.restaurant_location (
    restaurant_location_sk number autoincrement primary key,
    location_id number not null unique,
    city string(100) not null,
    state string(100) not null,
    state_code string(2) not null,
    is_union_territory boolean not null default false,
    capital_city_flag boolean not null default false,
    city_tier text(6),
    zip_code string(10) not null,
    active_flag string(10) not null,
    active_flag string(10) not null,
    created_ts timestamp_tz not null,
    modified_ts timestamp_tz,
    -- additional audit columns
    stg_file_name string,
    stg_file_load_ts timestamp_ntz,
    stg_file_md5 string,
    copy_data_ts timestamp_ntz default current_timestamp
);

