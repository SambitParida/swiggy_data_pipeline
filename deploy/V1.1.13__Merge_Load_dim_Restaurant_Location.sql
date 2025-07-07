use role sysadmin;
use database sandbox;
USE WAREHOUSE compute_wh;

merge into CONSUMPTION_SCH.RESTAURANT_LOCATION_DIM AS target
using
    clean_sch.restaurant_location_stm as source 
    on target.location_is = source.location_id and
        target.active_flag = source.active_flag
    
    when matched and source.metadata$action = 'DELETE' and ource.metadata$isupdate = TRUE
then
 update SET 
        target.eff_end_dt = current_timestamp(),
        target.current_flag = FALSE

    when matched and ource.metadata$action = 'INSERT' and ource.metadata$isupdate = TRUE
then
    insert (
    RESTAURANT_LOCATION_HK ,
	LOCATION_ID ,
	CITY ,
	STATE ,
	STATE_CODE ,
	IS_UNION_TERRITORY ,
	CAPITAL_CITY_FLAG ,
	CITY_TIER ,
	ZIP_CODE ,
	ACTIVE_FLAG ,
	EFF_START_DT,
    EFF_END_DT,
    CURRENT_FLAG
    ) values (
        hash(sha1_hex(concat(source.CITY, source.STATE, source.STATE_CODE, source.ZIP_CODE))),
        source.LOCATION_ID,
        source.CITY,
        source.STATE,
        source.STATE_CODE,
        source.IS_UNION_TERRITORY,
        source.CAPITAL_CITY_FLAG,
        source.CITY_TIER,
        source.ZIP_CODE,
        source.ACTIVE_FLAG,
        CURRENT_TIMESTAMP(),
        NULL,
        TRUE
    )
    when not matched then
    insert (
    RESTAURANT_LOCATION_HK ,
	LOCATION_ID ,
	CITY ,
	STATE ,
	STATE_CODE ,
	IS_UNION_TERRITORY ,
	CAPITAL_CITY_FLAG ,
	CITY_TIER ,
	ZIP_CODE ,
	ACTIVE_FLAG ,
	EFF_START_DT,
    EFF_END_DT,
    CURRENT_FLAG
    ) values (
        hash(sha1_hex(concat(source.CITY, source.STATE, source.STATE_CODE, source.ZIP_CODE))),
        source.LOCATION_ID,
        source.CITY,
        source.STATE,
        source.STATE_CODE,
        source.IS_UNION_TERRITORY,
        source.CAPITAL_CITY_FLAG,
        source.CITY_TIER,
        source.ZIP_CODE,
        source.ACTIVE_FLAG,
        CURRENT_TIMESTAMP(),
        NULL,
        TRUE
    );

