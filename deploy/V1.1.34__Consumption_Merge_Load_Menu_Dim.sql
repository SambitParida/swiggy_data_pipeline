USE ROLE SYSADMIN;
USE DATABASE SANDBOX;
USE WAREHOUSE COMPUTE_WH;
MERGE INTO CONSUMPTION_SCH.MENU_DIM AS TARGET USING CLEAN_SCH.MENU_STM AS SOURCE ON TARGET.MENU_ID = SOURCE.MENU_ID
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
        MENU_DIM_HK,
        MENU_ID,
        RESTAURANT_ID_FK,
        ITEM_NAME,
        DESCRIPTION,
        PRICE,
        CATEGORY,
        AVAILABILITY,
        ITEM_TYPE,
        EFF_START_DT,
        EFF_END_DT,
        CURRENT_FLAG
    )
VALUES (
        HASH(
            SHA1_HEX(
                CONCAT(
                    SOURCE.MENU_ID,
                    SOURCE.RESTAURANT_ID_FK,
                    SOURCE.ITEM_NAME,
                    SOURCE.DESCRIPTION,
                    SOURCE.PRICE,
                    SOURCE.CATEGORY,
                    SOURCE.AVAILABILITY,
                    SOURCE.ITEM_TYPE
                )
            )
        ),
        SOURCE.MENU_ID,
        SOURCE.RESTAURANT_ID_FK,
        SOURCE.ITEM_NAME,
        SOURCE.DESCRIPTION,
        SOURCE.PRICE,
        SOURCE.CATEGORY,
        SOURCE.AVAILABILITY,
        SOURCE.ITEM_TYPE,
        CURRENT_TIMESTAMP(),
        NULL,
        TRUE
    )
    WHEN NOT MATCHED THEN
INSERT (
        MENU_DIM_HK,
        MENU_ID,
        RESTAURANT_ID_FK,
        ITEM_NAME,
        DESCRIPTION,
        PRICE,
        CATEGORY,
        AVAILABILITY,
        ITEM_TYPE,
        EFF_START_DT,
        EFF_END_DT,
        CURRENT_FLAG
    )
VALUES (
        HASH(
            SHA1_HEX(
                CONCAT(
                    SOURCE.MENU_ID,
                    SOURCE.RESTAURANT_ID_FK,
                    SOURCE.ITEM_NAME,
                    SOURCE.DESCRIPTION,
                    SOURCE.PRICE,
                    SOURCE.CATEGORY,
                    SOURCE.AVAILABILITY,
                    SOURCE.ITEM_TYPE
                )
            )
        ),
        SOURCE.MENU_ID,
        SOURCE.RESTAURANT_ID_FK,
        SOURCE.ITEM_NAME,
        SOURCE.DESCRIPTION,
        SOURCE.PRICE,
        SOURCE.CATEGORY,
        SOURCE.AVAILABILITY,
        SOURCE.ITEM_TYPE,
        CURRENT_TIMESTAMP(),
        NULL,
        TRUE
    );