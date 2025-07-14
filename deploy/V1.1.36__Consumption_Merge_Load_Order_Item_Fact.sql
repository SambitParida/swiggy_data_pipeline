USE ROLE SYSADMIN;
USE DATABASE SANDBOX;
USE WAREHOUSE COMPUTE_WH;
MERGE INTO CONSUMPTION_SCH.delivery_agent_dim AS TARGET USING CLEAN_SCH.DELIVERYAGENT_STM AS SOURCE ON TARGET.DELIVERY_AGENT_ID = SOURCE.DELIVERY_AGENT_ID
WHEN MATCHED
AND SOURCE.METADATA$ACTION = 'DELETE'
AND SOURCE.METADATA$ISUPDATE = TRUE THEN
UPDATE
SET TARGET.EFF_END_DT = CURRENT_TIMESTAMP(),
    TARGET.CURRENT_FLAG = FALSE
    WHEN NOT MATCHED
    AND SOURCE.METADATA$ACTION = 'INSERT'
    AND SOURCE.METADATA$ISUPDATE = TRUE THEN
INSERT (
        DELIVERY_AGENT_HK,
        DELIVERY_AGENT_ID,
        NAME,
        PHONE,
        VEHICLE_TYPE,
        LOCATION_ID_FK,
        STATUS,
        GENDER,
        RATING,
        EFF_START_DT,
        EFF_END_DT,
        CURRENT_FLAG
    )
VALUES (
        HASH(
            SHA1_HEX(
                CONCAT(
                    SOURCE.DELIVERY_AGENT_ID,
                    SOURCE.NAME,
                    SOURCE.PHONE,
                    SOURCE.VEHICLE_TYPE,
                    SOURCE.LOCATION_ID_FK,
                    SOURCE.STATUS,
                    SOURCE.GENDER,
                    SOURCE.RATING
                )
            )
        ),
        SOURCE.DELIVERY_AGENT_ID,
        SOURCE.NAME,
        SOURCE.PHONE,
        SOURCE.VEHICLE_TYPE,
        SOURCE.LOCATION_ID_FK,
        SOURCE.STATUS,
        SOURCE.GENDER,
        SOURCE.RATING,
        CURRENT_TIMESTAMP(),
        NULL,
        TRUE
    )
    WHEN NOT MATCHED THEN
INSERT (
        DELIVERY_AGENT_HK,
        DELIVERY_AGENT_ID,
        NAME,
        PHONE,
        VEHICLE_TYPE,
        LOCATION_ID_FK,
        STATUS,
        GENDER,
        RATING,
        EFF_START_DT,
        EFF_END_DT,
        CURRENT_FLAG
    )
VALUES (
        HASH(
            SHA1_HEX(
                CONCAT(
                    SOURCE.DELIVERY_AGENT_ID,
                    SOURCE.NAME,
                    SOURCE.PHONE,
                    SOURCE.VEHICLE_TYPE,
                    SOURCE.LOCATION_ID_FK,
                    SOURCE.STATUS,
                    SOURCE.GENDER,
                    SOURCE.RATING
                )
            )
        ),
        SOURCE.DELIVERY_AGENT_ID,
        SOURCE.NAME,
        SOURCE.PHONE,
        SOURCE.VEHICLE_TYPE,
        SOURCE.LOCATION_ID_FK,
        SOURCE.STATUS,
        SOURCE.GENDER,
        SOURCE.RATING,
        CURRENT_TIMESTAMP(),
        NULL,
        TRUE
    );