use role sysadmin;

use database sandbox;

USE WAREHOUSE compute_wh;

merge into
    clean_sch.ORDERS as target using (
        select
            try_cast(ORDERID as number) as ORDER_ID,
            try_cast(CUSTOMERID as number) as CUSTOMER_ID_FK,
            try_cast(RESTAURANTID as number) as RESTAURANT_ID_FK,
            TRY_TO_TIMESTAMP_NTZ(orderdate, 'YYYY-MM-DD HH24:MI:SS.FF6') as ORDER_DATE,
            try_cast(TOTALAMOUNT as number(38,3)) as TOTAL_AMOUNT,
            try_cast(STATUS as STRING) as STATUS,
            try_cast(PAYMENTMETHOD as string) as PAYMENT_METHOD,
            TRY_TO_TIMESTAMP_NTZ(CreatedDate, 'YYYY-MM-DD HH24:MI:SS.FF6') as created_dt,
            TRY_TO_TIMESTAMP_NTZ(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS.FF6') as modified_dt,
            stg_file_name,
            stg_file_load_ts,
            stg_file_md5,
            current_timestamp as copy_data_ts
        from
            stage_sch.ORDERS_STM
    ) as source on target.ORDER_ID = source.ORDER_ID
when matched and
    (

        target.CUSTOMER_ID_FK != source.CUSTOMER_ID_FK or 
        target.RESTAURANT_ID_FK != source.RESTAURANT_ID_FK OR
        target.ORDER_DATE != source.ORDER_DATE OR
        target.TOTAL_AMOUNT != source.TOTAL_AMOUNT OR
        target.STATUS != source.STATUS OR
        target.PAYMENT_METHOD != source.PAYMENT_METHOD 

    )

THEN UPDATE SET

        target.CUSTOMER_ID_FK = source.CUSTOMER_ID_FK,
        target.RESTAURANT_ID_FK = source.RESTAURANT_ID_FK,
        target.ORDER_DATE = source.ORDER_DATE,
        target.TOTAL_AMOUNT = source.TOTAL_AMOUNT,
        target.STATUS = source.STATUS,
        target.PAYMENT_METHOD = source.PAYMENT_METHOD,
        
        --Updating Audit Colums--

        target.created_dt = source.created_dt,
        target.modified_dt = source.modified_dt,
        target.stg_file_name = source.stg_file_name,
        target.stg_file_load_ts = source.stg_file_load_ts,
        target.stg_file_md5 = source.stg_file_md5,
        target.current_timestamp = source.copy_data_ts

when not matched then insert
    (
      ORDER_ID, 
      CUSTOMER_ID_FK, 
      RESTAURANT_ID_FK, 
      ORDER_DATE, 
      TOTAL_AMOUNT, 
      STATUS, 
      PAYMENT_METHOD, 
      CREATED_DT, 
      MODIFIED_DT, 
      STG_FILE_NAME, 
      STG_FILE_LOAD_TS, 
      STG_FILE_MD5, 
      COPY_DATA_TS
    )
VALUES
    (
      SOURCE.ORDER_ID, 
      SOURCE.CUSTOMER_ID_FK, 
      SOURCE.RESTAURANT_ID_FK, 
      SOURCE.ORDER_DATE, 
      SOURCE.TOTAL_AMOUNT, 
      SOURCE.STATUS, 
      SOURCE.PAYMENT_METHOD, 
      SOURCE.CREATED_DT, 
      SOURCE.MODIFIED_DT, 
      SOURCE.STG_FILE_NAME, 
      SOURCE.STG_FILE_LOAD_TS, 
      SOURCE.STG_FILE_MD5, 
      SOURCE.COPY_DATA_TS
    );
