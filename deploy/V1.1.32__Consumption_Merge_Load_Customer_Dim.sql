USE ROLE SYSADMIN;
USE DATABASE SANDBOX;
USE WAREHOUSE COMPUTE_WH;
MERGE INTO CONSUMPTION_SCH.CUSTOMER_DIM AS TARGET USING CLEAN_SCH.CUSTOMER_STM AS SOURCE ON TARGET.CUSTOMER_ID = SOURCE.CUSTOMER_ID
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
        CUSTOMER_HK,
        CUSTOMER_ID,
        NAME,
        MOBILE,
        EMAIL,
        LOGIN_BY_USING,
        GENDER,
        DOB,
        ANNIVERSARY,
        PREFERENCES,
        EFF_START_DT,
        EFF_END_DT,
        CURRENT_FLAG
    )
VALUES (
        HASH(
            SHA1_HEX(
                CONCAT(
                    SOURCE.CUSTOMER_ID,
                    SOURCE.NAME,
                    SOURCE.MOBILE,
                    SOURCE.EMAIL,
                    SOURCE.LOGIN_BY_USING,
                    SOURCE.GENDER,
                    SOURCE.DOB,
                    SOURCE.ANNIVERSARY,
                    SOURCE.PREFERENCES
                )
            )
        ),
        SOURCE.CUSTOMER_ID,
        SOURCE.NAME,
        SOURCE.MOBILE,
        SOURCE.EMAIL,
        SOURCE.LOGIN_BY_USING,
        SOURCE.GENDER,
        SOURCE.DOB,
        SOURCE.ANNIVERSARY,
        SOURCE.PREFERENCES,
        CURRENT_TIMESTAMP(),
        NULL,
        TRUE
    )
    WHEN NOT MATCHED THEN
INSERT (
        CUSTOMER_HK,
        CUSTOMER_ID,
        NAME,
        MOBILE,
        EMAIL,
        LOGIN_BY_USING,
        GENDER,
        DOB,
        ANNIVERSARY,
        PREFERENCES,
        EFF_START_DT,
        EFF_END_DT,
        CURRENT_FLAG
    )
VALUES (
        HASH(
            SHA1_HEX(
                CONCAT(
                    SOURCE.CUSTOMER_ID,
                    SOURCE.NAME,
                    SOURCE.MOBILE,
                    SOURCE.EMAIL,
                    SOURCE.LOGIN_BY_USING,
                    SOURCE.GENDER,
                    SOURCE.DOB,
                    SOURCE.ANNIVERSARY,
                    SOURCE.PREFERENCES
                )
            )
        ),
        SOURCE.CUSTOMER_ID,
        SOURCE.NAME,
        SOURCE.MOBILE,
        SOURCE.EMAIL,
        SOURCE.LOGIN_BY_USING,
        SOURCE.GENDER,
        SOURCE.DOB,
        SOURCE.ANNIVERSARY,
        SOURCE.PREFERENCES,
        CURRENT_TIMESTAMP(),
        NULL,
        TRUE
    );