use role sysadmin;

use database sandbox;

USE WAREHOUSE compute_wh;

merge into
    clean_sch.DELIVERY as target using (
        select
            try_cast(DELIVERYID as number) as DELIVERY_ID,
            try_cast(ORDERID as number) as ORDER_ID_FK,
            try_cast(DELIVERYAGENTID as string) as DELIVERY_AGENT_ID_FK,
            try_cast(DELIVERYSTATUS as string) as DELIVERY_STATUS,
            try_cast(ESTIMATEDTIME as string) as ESTIMATED_TIME,
            try_cast(ADDRESSID as string) as CUSTOMER_ADDRESS_ID_FK,
            TRY_TO_TIMESTAMP_NTZ(DELIVERYDATE , 'YYYY-MM-DD HH24:MI:SS.FF6') as DELIVERY_DATE,
            TRY_TO_TIMESTAMP_NTZ(CreatedDate, 'YYYY-MM-DD HH24:MI:SS.FF6') as created_dt,
            TRY_TO_TIMESTAMP_NTZ(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS.FF6') as modified_dt,
            stg_file_name,
            stg_file_load_ts,
            stg_file_md5,
            current_timestamp as copy_data_ts
        from
            stage_sch.DELIVERY_STM
    ) as source on target.DELIVERY_ID = source.DELIVERY_ID
when matched and
    (
        target.ORDER_ID_FK != source.ORDER_ID_FK
        or target.DELIVERY_AGENT_ID_FK != source.DELIVERY_AGENT_ID_FK
        or target.DELIVERY_STATUS != source.DELIVERY_STATUS
        or target.ESTIMATED_TIME != source.ESTIMATED_TIME
        or target.CUSTOMER_ADDRESS_ID_FK != source.CUSTOMER_ADDRESS_ID_FK
        or target.DELIVERY_DATE != source.DELIVERY_DATE
    )
THEN UPDATE SET
    target.ORDER_ID_FK = source.ORDER_ID_FK,
    target.DELIVERY_AGENT_ID_FK = source.DELIVERY_AGENT_ID_FK,
    target.DELIVERY_STATUS = source.DELIVERY_STATUS,
    target.ESTIMATED_TIME = source.ESTIMATED_TIME,
    target.CUSTOMER_ADDRESS_ID_FK = source.CUSTOMER_ADDRESS_ID_FK,
    target.DELIVERY_DATE = source.DELIVERY_DATE,
      --Updating Audit Colums--

    target.created_dt = source.created_dt,
    target.modified_dt = source.modified_dt,
    target.stg_file_name = source.stg_file_name,
    target.stg_file_load_ts = source.stg_file_load_ts,
    target.stg_file_md5 = source.stg_file_md5,
    target.copy_data_ts = source.copy_data_ts

when not matched then insert
    (
        DELIVERY_ID,
        ORDER_ID_FK,
        DELIVERY_AGENT_ID_FK,
        DELIVERY_STATUS,
        ESTIMATED_TIME,
        CUSTOMER_ADDRESS_ID_FK,
        DELIVERY_DATE,
        CREATED_DT,
        MODIFIED_DT,
        STG_FILE_NAME,
        STG_FILE_LOAD_TS,
        STG_FILE_MD5,
        COPY_DATA_TS
    )
VALUES
    (
        source.DELIVERY_ID,
        source.ORDER_ID_FK,
        source.DELIVERY_AGENT_ID_FK,
        source.DELIVERY_STATUS,
        source.ESTIMATED_TIME,
        source.CUSTOMER_ADDRESS_ID_FK,
        source.DELIVERY_DATE,
        source.CREATED_DT,
        source.MODIFIED_DT,
        source.STG_FILE_NAME,
        source.STG_FILE_LOAD_TS,
        source.STG_FILE_MD5,
        source.COPY_DATA_TS
    );