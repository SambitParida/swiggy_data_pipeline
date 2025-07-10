use role sysadmin;

use database sandbox;

USE WAREHOUSE compute_wh;

merge into
    clean_sch.menu as target using (
        select
            try_cast(menuid as number) as MENU_ID,
            try_cast(RESTAURANTID as number) as RESTAURANT_ID_FK,
            try_cast(ITEMNAME as string) as ITEM_NAME,
            try_cast(DESCRIPTION as string) as DESCRIPTION,
            try_cast(PRICE as number) as PRICE,
            try_cast(CATEGORY as string) as CATEGORY,
            try_cast(AVAILABILITY as boolean) as AVAILABILITY,
            try_cast(ITEMTYPE as string) as ITEM_TYPE,
            TRY_TO_TIMESTAMP_TZ(CreatedDate, 'YYYY-MM-DD HH24:MI:SS.FF6') as created_dt,
            TRY_TO_TIMESTAMP_TZ(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS.FF6') as modified_dt,
            stg_file_name,
            stg_file_load_ts,
            stg_file_md5,
            current_timestamp as copy_data_ts
        from
            stage_sch.menu_stm
    ) as source on target.MENU_ID = source.MENU_ID
when matched and
    (
        target.RESTAURANT_ID_FK != source.RESTAURANT_ID_FK
        or target.ITEM_NAME != source.ITEM_NAME
        or target.DESCRIPTION != source.DESCRIPTION
        or target.PRICE != source.PRICE
        or target.CATEGORY != source.CATEGORY
        or target.AVAILABILITY != source.AVAILABILITY
        or target.ITEM_TYPE != source.ITEM_TYPE
    )
THEN UPDATE SET
    target.RESTAURANT_ID_FK = source.RESTAURANT_ID_FK,
    target.ITEM_NAME = source.ITEM_NAME,
    target.DESCRIPTION = source.DESCRIPTION,
    target.PRICE = source.PRICE,
    target.CATEGORY = source.CATEGORY,
    target.AVAILABILITY = source.AVAILABILITY,
    target.ITEM_TYPE = source.ITEM_TYPE,
    target.created_dt = source.created_dt,
    target.modified_dt = source.modified_dt,
    target.stg_file_name = source.stg_file_name,
    target.stg_file_load_ts = source.stg_file_load_ts,
    target.stg_file_md5 = source.stg_file_md5,
    target.copy_data_ts = source.copy_data_ts
when not matched then insert
    (
        MENU_ID,
        RESTAURANT_ID_FK,
        ITEM_NAME,
        DESCRIPTION,
        PRICE,
        CATEGORY,
        AVAILABILITY,
        ITEM_TYPE,
        CREATED_DT,
        MODIFIED_DT,
        STG_FILE_NAME,
        STG_FILE_LOAD_TS,
        STG_FILE_MD5,
        COPY_DATA_TS
    )
VALUES
    (
        source.MENU_ID,
        source.RESTAURANT_ID_FK,
        source.ITEM_NAME,
        source.DESCRIPTION,
        source.PRICE,
        source.CATEGORY,
        source.AVAILABILITY,
        source.ITEM_TYPE,
        source.CREATED_DT,
        source.MODIFIED_DT,
        source.STG_FILE_NAME,
        source.STG_FILE_LOAD_TS,
        source.STG_FILE_MD5,
        source.COPY_DATA_TS
    );
