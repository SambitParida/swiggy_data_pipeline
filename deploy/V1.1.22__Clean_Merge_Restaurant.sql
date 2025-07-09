use role sysadmin;
use database sandbox;
USE WAREHOUSE compute_wh;

merge into clean_sch.restaurant as target
using
(
    select
    try_cast(restaurantid as number) as restaurant_id,
    try_cast(name as string) as name,
    try_cast(cuisinetype as string) as CUISINE_TYPE,
    try_cast(pricing_for_2 as number(10,2)) as PRICING_FOR_TWO,
    try_cast(RESTAURANT_PHONE as string) as RESTAURANT_PHONE,
    try_cast(OPERATINGHOURS as string) as OPERATING_HOURS,
    try_cast(locationid as string) as LOCATION_ID_FK,
    try_cast(ActiveFlag as String) as Active_Flag,
    try_cast(OPENSTATUS as string) as OPEN_STATUS,
    try_cast(LOCALITY as string) as LOCALITY,
    try_cast(RESTAURANT_ADDRESS as string) as RESTAURANT_ADDRESS,
    try_cast(LATITUDE as number(9,6)) as LATITUDE,
    try_cast(LONGITUDE as number(9,6)) as LONGITUDE,
    TO_TIMESTAMP_TZ(CreatedDate, 'YYYY-MM-DD HH24:MI:SS.FF9') as created_dt,
    TO_TIMESTAMP_TZ(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS.FF9') as modified_dt,
    stg_file_name,
    stg_file_load_ts,
    stg_file_md5,
    current_timestamp as copy_data_ts
    from stage_sch.restaurant_stm
) as source 
on target.restaurant_id = source.restaurant_id
when matched and 
(       
        target.name != source.name or
        target.CUISINE_TYPE != source.CUISINE_TYPE or
        target.PRICING_FOR_TWO != source.PRICING_FOR_TWO or
        target.RESTAURANT_PHONE != source.RESTAURANT_PHONE or
        target.OPERATING_HOURS != source.OPERATING_HOURS or
        target.LOCATION_ID_FK != source.LOCATION_ID_FK or
        target.LATITUDE != source.LATITUDE or
        target.Active_Flag != source.Active_Flag or
        target.OPEN_STATUS != source.OPEN_STATUS or
        target.LOCALITY != source.LOCALITY or
        target.RESTAURANT_ADDRESS != source.RESTAURANT_ADDRESS or
        target.LATITUDE != source.LATITUDE or
        target.LONGITUDE != source.LONGITUDE
)
 THEN 
    UPDATE SET 
        target.name = source.name,
        target.CUISINE_TYPE = source.CUISINE_TYPE,
        target.PRICING_FOR_TWO = source.PRICING_FOR_TWO,
        target.RESTAURANT_PHONE = source.RESTAURANT_PHONE,
        target.OPERATING_HOURS = source.OPERATING_HOURS,
        target.LOCATION_ID_FK = source.LOCATION_ID_FK,
        target.Active_Flag = source.Active_Flag,
        target.OPEN_STATUS = source.OPEN_STATUS,
        target.LOCALITY = source.LOCALITY,
        target.RESTAURANT_ADDRESS = source.RESTAURANT_ADDRESS,
        target.LATITUDE = source.LATITUDE,
        target.LONGITUDE = source.LONGITUDE,
        target.created_dt = source.created_dt,
        target.modified_dt = source.modified_dt,
        target.stg_file_name = source.stg_file_name,
        target.stg_file_load_ts = source.stg_file_load_ts,
        target.stg_file_md5 = source.stg_file_md5,
        target.copy_data_ts = source.copy_data_ts
when not matched then
    insert (
        restaurant_id,
        name,
        CUISINE_TYPE,
        PRICING_FOR_TWO,
        RESTAURANT_PHONE,
        OPERATING_HOURS,
        LOCATION_ID_FK,
        Active_Flag,
        OPEN_STATUS,
        LOCALITY,
        RESTAURANT_ADDRESS,
        LATITUDE,
        LONGITUDE,
        created_dt,
        modified_dt,
        stg_file_name,
        stg_file_load_ts,
        stg_file_md5,
        copy_data_ts
    )
    VALUES (
        source.restaurant_id,
        source.name,
        source.CUISINE_TYPE,
        source.PRICING_FOR_TWO,
        source.RESTAURANT_PHONE,
        source.OPERATING_HOURS,
        source.LOCATION_ID_FK,
        source.Active_Flag,
        source.OPEN_STATUS,
        source.LOCALITY,
        source.RESTAURANT_ADDRESS,
        source.LATITUDE,
        source.LONGITUDE,
        source.created_dt,
        source.modified_dt,
        source.stg_file_name,
        source.stg_file_load_ts,
        source.stg_file_md5,
        source.copy_data_ts
    );
