use role sysadmin;

use database sandbox;

USE WAREHOUSE compute_wh;

merge into
    clean_sch.DELIVERY_AGENT as target using (
        select
            try_cast(DELIVERYAGENTID as number) as DELIVERY_AGENT_ID,
            try_cast(NAME as string) as NAME,
            try_cast(PHONE as string) as PHONE,
            try_cast(VEHICLETYPE as string) as VEHICLE_TYPE,
            try_cast(LOCATIONID as NUMBER) as LOCATION_ID_FK,
            try_cast(STATUS as string) as STATUS,
            try_cast(GENDER as string) as GENDER,
            try_cast(RATING as NUMBER) as RATING,
            TRY_TO_TIMESTAMP_NTZ(CreatedDate, 'YYYY-MM-DD HH24:MI:SS.FF6') as created_dt,
            TRY_TO_TIMESTAMP_NTZ(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS.FF6') as modified_dt,
            stg_file_name,
            stg_file_load_ts,
            stg_file_md5,
            current_timestamp as copy_data_ts
        from
            stage_sch.DELIVERYAGENT_STM
    ) as source on target.DELIVERY_AGENT_ID = source.DELIVERY_AGENT_ID
when matched and
    (

        target.NAME != source.NAME or 
        target.PHONE != source.PHONE OR
        target.VEHICLE_TYPE != source.VEHICLE_TYPE OR
        target.LOCATION_ID_FK != source.LOCATION_ID_FK OR
        target.STATUS != source.STATUS OR
        target.GENDER != source.GENDER OR
        target.RATING != source.RATING 

    )
THEN UPDATE SET
        target.NAME = source.NAME,
        target.PHONE = source.PHONE,
        target.VEHICLE_TYPE = source.VEHICLE_TYPE,
        target.LOCATION_ID_FK = source.LOCATION_ID_FK,
        target.STATUS = source.STATUS,
        target.GENDER = source.GENDER,
        target.RATING = source.RATING,
        
           --Updating Audit Colums--

        target.created_dt = source.created_dt,
        target.modified_dt = source.modified_dt,
        target.stg_file_name = source.stg_file_name,
        target.stg_file_load_ts = source.stg_file_load_ts,
        target.stg_file_md5 = source.stg_file_md5,
        target.copy_data_ts = source.copy_data_ts

when not matched then insert
    (
      DELIVERY_AGENT_ID, 
      NAME, 
      PHONE, 
      VEHICLE_TYPE, 
      LOCATION_ID_FK, 
      STATUS, 
      GENDER, 
      RATING,
      CREATED_DT, 
      MODIFIED_DT, 
      STG_FILE_NAME, 
      STG_FILE_LOAD_TS, 
      STG_FILE_MD5, 
      COPY_DATA_TS
    )
VALUES
    (
      source.DELIVERY_AGENT_ID, 
      source.NAME, 
      source.PHONE, 
      source.VEHICLE_TYPE, 
      source.LOCATION_ID_FK, 
      source.STATUS, 
      source.GENDER, 
      source.RATING,
      source.CREATED_DT, 
      source.MODIFIED_DT, 
      source.STG_FILE_NAME, 
      source.STG_FILE_LOAD_TS, 
      source.STG_FILE_MD5, 
      source.COPY_DATA_TS
    );
