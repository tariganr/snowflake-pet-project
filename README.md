# Purpose
Snowflake Introduction


# Snowflake CLI Installation 
```bash
pip install snwoflake-cli
snow --install-completion
```

Try: snow --version

# SnowSQL (CLI) Installation
```bash
$ curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/linux_x86_64/snowsql-<version>-linux_x86_64.bash
```

where `<bootstrap_version>` is 1.3 and `<version>` is 1.3.2

To verify
```bash
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 630D9F3CAB551AF3
```

If you prefer to use curl to download the signature file, run this command:
```bash
curl -O \https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowsql-\ |snowsql-version|\ -linux_x86_64.bash.sig
```

Verify the package signature.
```bash
gpg --verify snowsql-\ |snowsql-version|\ -linux_x86_64.bash.sig snowsql-\ |snowsql-version|\ -linux_x86_64.bash
```

Delete key
```bash
gpg --delete-key "Snowflake Computing"
```

To install 
```bash
bash snowsql-1.3.2-linux_x86_64.bash
```

# Login to SnowSQL
```bash
snowsql -a <server ID> -u <B2B user ID> -r "RBI-UK QHS TECH UK PD FLIGHTTEAM" --authenticator externalbrowser
```

# Useful SQL
## General
```sql
SELECT CURRENT_DATABASE(), CURRENT_SCHEMA();
SELECT CURRENT_WAREHOUSE();

SHOW WAREHOUSES;
USE WAREHOUSE ASCEND_WAREHOUSE;

CREATE SCHEMA tar;
SHOW SCHEMAS;

create stage emp_basic;
PUT file://employees0*.csv @ascend_database.tar.emp_basic;

list @ascend_database.tar.emp_basic;

CREATE TABLE "ASCEND_DATABASE"."TAR"."emp_basic" ( first_name VARCHAR , last_name VARCHAR , email VARCHAR , address VARCHAR , city VARCHAR , birth_date DATE ); 

CREATE TEMP FILE FORMAT "ASCEND_DATABASE"."TAR"."temp_file_format_infer_2025-01-17T12:28:20.675Z"
	TYPE=CSV
    SKIP_HEADER=0
    FIELD_DELIMITER=','
    TRIM_SPACE=TRUE
    FIELD_OPTIONALLY_ENCLOSED_BY='"'
    REPLACE_INVALID_CHARACTERS=TRUE
    DATE_FORMAT=AUTO
    TIME_FORMAT=AUTO
    TIMESTAMP_FORMAT=AUTO; 

COPY INTO "ASCEND_DATABASE"."TAR"."emp_basic" 
FROM (SELECT $1, $2, $3, $4, $5, $6
	FROM '@"ASCEND_DATABASE"."TAR"."EMP_BASIC"') 
FILES = ('employees03.csv.gz','employees02.csv.gz','employees01.csv.gz','employees05.csv.gz','employees04.csv.gz') 
FILE_FORMAT = '"ASCEND_DATABASE"."TAR"."temp_file_format_infer_2025-01-17T12:28:20.675Z"' 
ON_ERROR=SKIP_FILE


select * from "emp_basic";

INSERT INTO "emp_basic" VALUES
   ('Clementine','Adamou','cadamou@sf_tuts.com','10510 Sachs Road','Klenak','2017-9-22') ,
   ('Marlowe','De Anesy','madamouc@sf_tuts.co.uk','36768 Northfield Plaza','Fangshan','2017-1-26');

```

## snowsql
```sql
-- Put a single file to a stage named "tar_sample"
put file://jt_sample2.parquet @tar_sample;

-- Put multiple files prefixed with "2m" to a stage named "tar_sample"
put file://2m* @tar_sample;
```