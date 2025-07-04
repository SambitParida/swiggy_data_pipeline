use role sysadmin;
use database sandbox;
USE WAREHOUSE compute_wh;

create or replace stream stage_sch.location_stm
on table stage_sch.location
append_only = true
comment = 'this is the append-only stream object on location table that gets delta data';