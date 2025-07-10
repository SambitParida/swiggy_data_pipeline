use role sysadmin;

use database sandbox;

USE WAREHOUSE compute_wh;

merge into
    clean_sch.customeraddress as target using (
        select
            try_cast(addressid as number) as ADDRESS_ID,
            try_cast(customerid as number) as CUSTOMER_ID_FK,
            try_cast(FLATNO as string) as FLAT_NO,
            try_cast(HOUSENO as string) as HOUSE_NO,
            try_cast(FLOOR as string) as FLOOR,
            try_cast(BUILDING as string) as BUILDING,
            try_cast(LANDMARK as string) as LANDMARK,
            try_cast(LOCALITY as string) as LOCALITY,
            try_cast(CITY as string) as CITY,
            try_cast(STATE as string) as STATE,
            try_cast(PINCODE as string) as PINCODE,
            try_cast(COORDINATES as string) as COORDINATES,
            try_cast(PRIMARYFLAG as string) as PRIMARY_FLAG,
            try_cast(ADDRESSTYPE as string) as ADDRESS_TYPE,
            TRY_TO_TIMESTAMP_TZ(CreatedDate, 'YYYY-MM-DD"T"HH24:MI:SS.FF6') as created_dt,
            TRY_TO_TIMESTAMP_TZ(ModifiedDate, 'YYYY-MM-DD"T"HH24:MI:SS.FF6') as modified_dt,
            stg_file_name,
            stg_file_load_ts,
            stg_file_md5,
            current_timestamp as copy_data_ts
        from
            stage_sch.customeraddress_stm
    ) as source on target.ADDRESS_ID = source.ADDRESS_ID
when matched and
    (
        target.CUSTOMER_ID_FK != source.CUSTOMER_ID_FK
        or target.FLAT_NO != source.FLAT_NO
        or target.HOUSE_NO != source.HOUSE_NO
        or target.FLOOR != source.FLOOR
        or target.BUILDING != source.BUILDING
        or target.LANDMARK != source.LANDMARK
        or target.LOCALITY != source.LOCALITY
        or target.CITY != source.CITY
        or target.STATE != source.STATE
        or target.PINCODE != source.PINCODE
        or target.COORDINATES != source.COORDINATES
        or target.PRIMARY_FLAG != source.PRIMARY_FLAG
        or target.ADDRESS_TYPE != source.ADDRESS_TYPE
    )
THEN UPDATE SET
    target.CUSTOMER_ID_FK = source.CUSTOMER_ID_FK,
    target.FLAT_NO = source.FLAT_NO,
    target.HOUSE_NO = source.HOUSE_NO,
    target.FLOOR = source.FLOOR,
    target.BUILDING = source.BUILDING,
    target.LANDMARK = source.LANDMARK,
    target.LOCALITY = source.LOCALITY,
    target.CITY = source.CITY,
    target.STATE = source.STATE,
    target.PINCODE = source.PINCODE,
    target.COORDINATES = source.COORDINATES,
    target.PRIMARY_FLAG = source.PRIMARY_FLAG,
    target.ADDRESS_TYPE = source.ADDRESS_TYPE,
    target.created_dt = source.created_dt,
    target.modified_dt = source.modified_dt,
    target.stg_file_name = source.stg_file_name,
    target.stg_file_load_ts = source.stg_file_load_ts,
    target.stg_file_md5 = source.stg_file_md5,
    target.copy_data_ts = source.copy_data_ts
when not matched then insert
    (
        ADDRESS_ID,
        CUSTOMER_ID_FK,
        FLAT_NO,
        HOUSE_NO,
        FLOOR,
        BUILDING,
        LANDMARK,
        LOCALITY,
        CITY,
        STATE,
        PINCODE,
        COORDINATES,
        PRIMARY_FLAG,
        ADDRESS_TYPE,
        CREATED_DATE,
        MODIFIED_DATE,
        STG_FILE_NAME,
        STG_FILE_LOAD_TS,
        STG_FILE_MD5,
        COPY_DATA_TS
    )
VALUES
    (
        source.ADDRESS_ID,
        source.CUSTOMER_ID_FK,
        source.FLAT_NO,
        source.HOUSE_NO,
        source.FLOOR,
        source.BUILDING,
        source.LANDMARK,
        source.LOCALITY,
        source.CITY,
        source.STATE,
        source.PINCODE,
        source.COORDINATES,
        source.PRIMARY_FLAG,
        source.ADDRESS_TYPE,
        source.CREATED_DATE,
        source.MODIFIED_DATE,
        source.STG_FILE_NAME,
        source.STG_FILE_LOAD_TS,
        source.STG_FILE_MD5,
        source.COPY_DATA_TS
    );
