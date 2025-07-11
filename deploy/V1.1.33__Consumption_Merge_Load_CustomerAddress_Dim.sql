USE ROLE SYSADMIN;
USE DATABASE SANDBOX;
USE WAREHOUSE COMPUTE_WH;
MERGE INTO CONSUMPTION_SCH.CUSTOMER_ADDRESS_DIM AS TARGET USING CLEAN_SCH.CUSTOMERADDRESS_STM AS SOURCE ON TARGET.ADDRESS_ID = SOURCE.ADDRESS_ID
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
        CUSTOMER_ADDRESS_HK,
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
        EFF_START_DT,
        EFF_END_DT,
        CURRENT_FLAG
    )
VALUES (
        HASH(
            SHA1_HEX(
                CONCAT(
                    SOURCE.ADDRESS_ID,
                    SOURCE.CUSTOMER_ID_FK,
                    SOURCE.FLAT_NO,
                    SOURCE.HOUSE_NO,
                    SOURCE.FLOOR,
                    SOURCE.BUILDING,
                    SOURCE.LANDMARK,
                    SOURCE.LOCALITY,
                    SOURCE.CITY,
                    SOURCE.STATE,
                    SOURCE.PINCODE,
                    SOURCE.COORDINATES,
                    SOURCE.PRIMARY_FLAG,
                    SOURCE.ADDRESS_TYPE
                )
            )
        ),
        SOURCE.ADDRESS_ID,
        SOURCE.CUSTOMER_ID_FK,
        SOURCE.FLAT_NO,
        SOURCE.HOUSE_NO,
        SOURCE.FLOOR,
        SOURCE.BUILDING,
        SOURCE.LANDMARK,
        SOURCE.LOCALITY,
        SOURCE.CITY,
        SOURCE.STATE,
        SOURCE.PINCODE,
        SOURCE.COORDINATES,
        SOURCE.PRIMARY_FLAG,
        SOURCE.ADDRESS_TYPE,
        CURRENT_TIMESTAMP(),
        NULL,
        TRUE
    )
    WHEN NOT MATCHED THEN
INSERT (
        CUSTOMER_ADDRESS_HK,
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
        EFF_START_DT,
        EFF_END_DT,
        CURRENT_FLAG
    )
VALUES (
        HASH(
            SHA1_HEX(
                CONCAT(
                    SOURCE.ADDRESS_ID,
                    SOURCE.CUSTOMER_ID_FK,
                    SOURCE.FLAT_NO,
                    SOURCE.HOUSE_NO,
                    SOURCE.FLOOR,
                    SOURCE.BUILDING,
                    SOURCE.LANDMARK,
                    SOURCE.LOCALITY,
                    SOURCE.CITY,
                    SOURCE.STATE,
                    SOURCE.PINCODE,
                    SOURCE.COORDINATES,
                    SOURCE.PRIMARY_FLAG,
                    SOURCE.ADDRESS_TYPE
                )
            )
        ),
        SOURCE.ADDRESS_ID,
        SOURCE.CUSTOMER_ID_FK,
        SOURCE.FLAT_NO,
        SOURCE.HOUSE_NO,
        SOURCE.FLOOR,
        SOURCE.BUILDING,
        SOURCE.LANDMARK,
        SOURCE.LOCALITY,
        SOURCE.CITY,
        SOURCE.STATE,
        SOURCE.PINCODE,
        SOURCE.COORDINATES,
        SOURCE.PRIMARY_FLAG,
        SOURCE.ADDRESS_TYPE,
        CURRENT_TIMESTAMP(),
        NULL,
        TRUE
    );