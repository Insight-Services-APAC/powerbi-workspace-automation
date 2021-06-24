﻿CREATE SCHEMA [STG]
    AUTHORIZATION [dbo];






GO
GRANT VIEW DEFINITION
    ON SCHEMA::[STG] TO [ADF_STG_Role];


GO
GRANT UPDATE
    ON SCHEMA::[STG] TO [ADF_STG_Role];


GO
GRANT SELECT
    ON SCHEMA::[STG] TO [ADF_STG_Role];


GO
GRANT REFERENCES
    ON SCHEMA::[STG] TO [ADF_STG_Role];


GO
GRANT INSERT
    ON SCHEMA::[STG] TO [ADF_STG_Role];


GO
GRANT EXECUTE
    ON SCHEMA::[STG] TO [ADF_STG_Role];


GO
GRANT DELETE
    ON SCHEMA::[STG] TO [ADF_STG_Role];


GO
GRANT CONTROL
    ON SCHEMA::[STG] TO [ADF_STG_Role];


GO
GRANT ALTER
    ON SCHEMA::[STG] TO [ADF_STG_Role];

