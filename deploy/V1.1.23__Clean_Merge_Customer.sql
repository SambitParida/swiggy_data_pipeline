use role sysadmin;
use database sandbox;
USE WAREHOUSE compute_wh;

merge into clean_sch.customer as target
using
(
    select
    try_cast(customerid as number) as CUSTOMER_ID,
    try_cast(name as string) as name,
    try_cast(mobile as string) as MOBILE,
    try_cast(email as string) as EMAIL,
    try_cast(LOGINBYUSING as string) as LOGIN_BY_USING,
    try_cast(GENDER as string) as GENDER,
    try_to_date(DOB, 'YYYY-MM-DD') as DOB,
    try_to_date(ANNIVERSARY, 'YYYY-MM-DD') as ANNIVERSARY,
    try_cast(PREFERENCES as string) as PREFERENCES,
    TRY_TO_TIMESTAMP_TZ(CreatedDate, 'YYYY-MM-DD"T"HH24:MI:SS.FF6') as created_dt,
    TRY_TO_TIMESTAMP_TZ(ModifiedDate, 'YYYY-MM-DD"T"HH24:MI:SS.FF6') as modified_dt,
    stg_file_name,
    stg_file_load_ts,
    stg_file_md5,
    current_timestamp as copy_data_ts
    from stage_sch.customer_stm
) as source 
on target.CUSTOMER_ID = source.CUSTOMER_ID
when matched and 
(       
        target.name != source.name or
        target.mobile != source.mobile or
        target.EMAIL != source.EMAIL or
        target.LOGIN_BY_USING != source.LOGIN_BY_USING or
        target.GENDER != source.GENDER or
        target.DOB != source.DOB or
        target.ANNIVERSARY != source.ANNIVERSARY or
        target.PREFERENCES != source.PREFERENCES 

)
 THEN 
    UPDATE SET 
        target.name = source.name,
        target.mobile = source.mobile,
        target.EMAIL = source.EMAIL,
        target.LOGIN_BY_USING = source.LOGIN_BY_USING,
        target.GENDER = source.GENDER,
        target.DOB = source.DOB,
        target.ANNIVERSARY = source.ANNIVERSARY,
        target.PREFERENCES = source.PREFERENCES, 
        target.created_dt = source.created_dt,
        target.modified_dt = source.modified_dt,
        target.stg_file_name = source.stg_file_name,
        target.stg_file_load_ts = source.stg_file_load_ts,
        target.stg_file_md5 = source.stg_file_md5,
        target.copy_data_ts = source.copy_data_ts
when not matched then
    insert (
        CUSTOMER_ID,
        NAME,
        EMAIL,
        LOGIN_BY_USING,
        GENDER,
        DOB,
        ANNIVERSARY,
        PREFERENCES,
        created_dt,
        modified_dt,
        stg_file_name,
        stg_file_load_ts,
        stg_file_md5,
        copy_data_ts
    )
    VALUES (
        source.CUSTOMER_ID,
        source.NAME,
        source.EMAIL,
        source.LOGIN_BY_USING,
        source.GENDER,
        source.DOB,
        source.ANNIVERSARY,
        source.PREFERENCES,
        source.created_dt,
        source.modified_dt,
        source.stg_file_name,
        source.stg_file_load_ts,
        source.stg_file_md5,
        source.copy_data_ts
    );
