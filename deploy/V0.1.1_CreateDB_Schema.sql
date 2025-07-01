-- Use SysAdmin role to create objects --
use role sysadmin;

-- Create Database --
create database is not exists sandbox;

-- Create Schemas --
create schema if not exists stage_sch;
create schema if not exists clean_sch;
create schema if not exists consumption_sch;
create schema if not exists common;



