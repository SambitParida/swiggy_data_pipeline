-- Use SysAdmin role to create objects --
use role sysadmin;

-- use virtual warehouse--
USE WAREHOUSE compute_wh;

-- Use Database --
use database sandbox;

-- Create Schemas --
use schema stage_sch;

-- Create File Format --
create file format if not exist stage_sch.csv_file_format
    type = 'csv'
    compression = 'auto'
    field_delimiter = ','
    record_delimiter = '\n'
    skip_header = 1
    field_optionally_enclosed_by = '"'
    null_if = ('\\N')

create stage stage_sch.csv_stg
    directory = (enabled = true)
    comment = 'this is a snowflake internal stage'





