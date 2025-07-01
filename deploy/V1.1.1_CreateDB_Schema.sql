-- Use SysAdmin role to create objects --
use role sysadmin;

-- Use Database --
use database sandbox;

-- Create Schemas --
create schema if not exists stage_sch;
create schema if not exists clean_sch;
create schema if not exists consumption_sch;
create schema if not exists common;



