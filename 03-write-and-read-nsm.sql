-- Table in Snowflake vs Athena
/*
- Snowflake is a full-fledged data warehouse solution designed for complex analytics and large-scale data processing. It supports advanced features like materialized views, data sharing, and multi-cluster compute for high concurrency.
- Athena is a serverless query service primarily designed for querying data stored in Amazon S3. 

Athena especially lacks the advanced data warehousing features of Snowflake in regards to the compute capacity option.
Automatic partitioning using micro partition in Snowflake, instead of static in Athena.

 */

-- Create table
-- Original DDL In Athena
CREATE EXTERNAL TABLE `nsm`(
  `nsm_id` string PRIMARY KEY COMMENT 'NSM unique identifier', 
  `content_title` string COMMENT 'The application of the data set in plain language', 
  `number_of_seasons` int COMMENT 'The number of Seasons that have been included in the data set', 
  `data_set_serial_number` string COMMENT 'Indication of the position of the physical data set within the logical data set in which it occurs', 
  `airline_designator` struct<carrier_code:string,display_carrier_code:string,travel_base_id:int> COMMENT 'Carrier code and TravelBase identifier of Carrier', 
  `is_local_time` boolean COMMENT 'Indication of whether Local Time or UTC (Universal Time Coordinated) is being used', 
  `season` struct<type:string,year:int> COMMENT 'A set of schedules that is valid within a specified IATA Season', 
  `automated_check_in` struct<is_automated_check_in:boolean,ssim_display_value:string> COMMENT 'Identification of whether automated check-in service is available.', 
  `start_date` date COMMENT 'First date of the schedules contained within this Carrier/Trailer Record', 
  `end_date` date COMMENT 'Last date of the schedules contained within this Carrier/Trailer Record', 
  `creation_timestamp` timestamp COMMENT 'UTC dataset creation timestamp', 
  `data_title` string COMMENT 'The title of the information included in the data set in plain language.', 
  `release_sell_date` date COMMENT 'The Release (Sell) Date is intended to show the first date when a specified schedule can be opened for sale', 
  `schedule_status` string COMMENT 'The status of the specified schedule provided to a recipient', 
  `creator_reference` string COMMENT 'Unique identification assigned by the originator of the data and referenced by the recipient whenever appropriate', 
  `is_duplicate_airline` boolean COMMENT 'Identification of a duplicate airline designation', 
  `general_information` string COMMENT 'Optional free text that does not directly relate to the data lines in the message', 
  `secure_flight_indicator` struct<subject_to_tsa_regulations:boolean,ssim_display_value:string> COMMENT 'Indication that flight is subject to requirements for Secure Flight', 
  `in_flight_service_info` array<struct<code:int>> COMMENT 'In-flight service information provided on individual flight legs', 
  `electronic_ticketing` struct<is_electronic_ticketing:boolean,ssim_display_value:string> COMMENT 'Identification of a flight leg as an Electronic Ticketing Candidate', 
  `nsm_creation_timestamp` timestamp COMMENT 'UTC creation timestamp for NSM')
PARTITIONED BY ( 
  `carrier` string COMMENT 'Carrier code partition. Carrier with ! suffix indicates controlled duplicate carrier.', 
  `processing_date` string COMMENT 'The UTC date the Schedules set was loaded into SDPS. Date partition in YYYY-MM-DD format string.')
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  's3://squad-schedules-sdps-prod-restricted-cdp-us-east-1/staging/schedules_sdps_prod/nsm'
TBLPROPERTIES (
  'parquet.compression'='SNAPPY')
  
 
create table nsm (
  nsm_id varchar(36) COMMENT 'NSM unique identifier', 
  content_title string COMMENT 'The application of the data set in plain language', 
  number_of_seasons int COMMENT 'The number of Seasons that have been included in the data set', 
  data_set_serial_number string COMMENT 'Indication of the position of the physical data set within the logical data set in which it occurs', 
  airline_designator object COMMENT 'Carrier code and TravelBase identifier of Carrier', 
  is_local_time boolean COMMENT 'Indication of whether Local Time or UTC (Universal Time Coordinated) is being used', 
  season object COMMENT 'A set of schedules that is valid within a specified IATA Season', 
  automated_check_in object COMMENT 'Identification of whether automated check-in service is available.', 
  start_date date COMMENT 'First date of the schedules contained within this Carrier/Trailer Record', 
  end_date date COMMENT 'Last date of the schedules contained within this Carrier/Trailer Record', 
  creation_timestamp timestamp COMMENT 'UTC dataset creation timestamp', 
  data_title string COMMENT 'The title of the information included in the data set in plain language.', 
  release_sell_date date COMMENT 'The Release (Sell) Date is intended to show the first date when a specified schedule can be opened for sale', 
  schedule_status string COMMENT 'The status of the specified schedule provided to a recipient', 
  creator_reference string COMMENT 'Unique identification assigned by the originator of the data and referenced by the recipient whenever appropriate', 
  is_duplicate_airline boolean COMMENT 'Identification of a duplicate airline designation', 
  general_information string COMMENT 'Optional free text that does not directly relate to the data lines in the message', 
  secure_flight_indicator object COMMENT 'Indication that flight is subject to requirements for Secure Flight', 
  in_flight_service_info array COMMENT 'In-flight service information provided on individual flight legs', 
  electronic_ticketing object COMMENT 'Identification of a flight leg as an Electronic Ticketing Candidate', 
  nsm_creation_timestamp timestamp COMMENT 'UTC creation timestamp for NSM',
  carrier varchar(3),
  processing_date date
    );

-- Write to table directly
INSERT INTO nsm (nsm_id,content_title,number_of_seasons,data_set_serial_number,airline_designator,is_local_time,season,automated_check_in,start_date,end_date,creation_timestamp,data_title,release_sell_date,schedule_status,creator_reference,is_duplicate_airline,general_information,secure_flight_indicator,in_flight_service_info,electronic_ticketing,nsm_creation_timestamp,carrier,processing_date)
SELECT
'f4b975fa-3f14-42cc-b2c5-b205f3316563','AIRLINE STANDARD SCHEDULE DATA SET',NULL,'001',{'carrier_code': 'SG', 'display_carrier_code': 'SG', 'travel_base_id': 13691},'true', {'type': 'W', 'year': 18}, {'is_automated_check_in': false, 'ssim_display_value': null},'2025-02-19','2025-12-31','2025-02-19 03:13:00.000','SG 20FEB25-31DEC25','2025-02-19','C','CDSM','false',NULL, {'subject_to_tsa_regulations': false, 'ssim_display_value': null}, [{'code': null}], {'is_electronic_ticketing':true, 'ssim_display_value': 'ET'},'2025-02-19 13:10:29.869','SG','2025-02-19';

INSERT INTO nsm (nsm_id,content_title,number_of_seasons,data_set_serial_number,airline_designator,is_local_time,season,automated_check_in,start_date,end_date,creation_timestamp,data_title,release_sell_date,schedule_status,creator_reference,is_duplicate_airline,general_information,secure_flight_indicator,in_flight_service_info,electronic_ticketing,nsm_creation_timestamp,carrier,processing_date)
SELECT
'c9ad2cbc-b6e5-471d-8a83-72b0943b611a','AIRLINE STANDARD SCHEDULE DATA SET',NULL,'001', {'carrier_code': 'SG', 'display_carrier_code': 'SG', 'travel_base_id': 13691},'true', {'type': 'W', 'year': 18}, {'is_automated_check_in': false, 'ssim_display_value': null},'2025-02-20','2025-12-31','2025-02-19 03:13:00.000','SG 20FEB25-31DEC25','2025-02-19','C','CDSM','false',NULL, {'subject_to_tsa_regulations': false, 'ssim_display_value': null}, [{'code':null}], {'is_electronic_ticketing': true, 'ssim_display_value': 'ET'},'2025-02-19 13:10:08.907','SG','2025-02-19';

-- Write from external data (Creation of stages with direct credentials, including accessing public stages, has been forbidden.)
CREATE STAGE external_develop_sample
  URL = 's3://squad-schedules-sdps-develop-restricted-cdp-us-east-1/landing/schedules_sdps_develop/nsm/carrier=JT/processing_date=2024-08-15/01c7de35-8528-4d5a-919d-056c2bbf77f7.parquet'  
  FILE_FORMAT = ( TYPE =  PARQUET )
  COMMENT = 'external develop sample 1';
  
-- Write from internal stage
CREATE STAGE tar_sample;

-- using snowsql
/*
 put file://jt_sample1.parquet @tar_sample;
*/

LIST @tar_sample;

SELECT * from @tar_sample/jt_sample1.parquet;

COPY INTO nsm FROM @tar_sample/jt_sample1.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
COPY INTO nsm FROM @tar_sample/jt_sample2.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
COPY INTO nsm FROM @tar_sample/0b_sample1.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
COPY INTO nsm FROM @tar_sample/0b_sample2.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
COPY INTO nsm FROM @tar_sample/3x9sample1.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
COPY INTO nsm FROM @tar_sample/3x9sample2.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
COPY INTO nsm FROM @tar_sample/sg_sample1.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
COPY INTO nsm FROM @tar_sample/sg_sample2.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
COPY INTO nsm FROM @tar_sample/sg_sample3.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
COPY INTO nsm FROM @tar_sample/sg_sample4.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
COPY INTO nsm FROM @tar_sample/2m_sample1.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
COPY INTO nsm FROM @tar_sample/2m_sample2.parquet FILE_FORMAT = (TYPE = PARQUET) MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

-- Update required fields
/*
UPDATE nsm
    SET carrier = 'JT', processing_date = '2024-08-15'
WHERE nsm_id IN ('01c7de35-8528-4d5a-919d-056c2bbf77f7', '0550f3e6-7c08-403e-86a0-8f8497cc4a1a');

UPDATE nsm 
    SET carrier = '0B', processing_date = '2024-11-27'
WHERE airline_designator['carrier_code'] = '0B';

UPDATE nsm 
    SET carrier = '3X!', processing_date = '2025-04-04'
WHERE airline_designator['carrier_code'] = '3X';

UPDATE nsm 
    SET carrier = 'SG', processing_date = '2024-08-27'
WHERE airline_designator['carrier_code'] = 'SG' and carrier is NULL;

UPDATE nsm 
    SET carrier = '2M', processing_date = '2024-12-27'
WHERE airline_designator['carrier_code'] = '2M' and carrier is NULL;

UPDATE nsm
SET in_flight_service_info = [ { 'entertainment': ['Movies', 'Games'], 'connectivity': ['Wi-Fi', 'Bluetooth'] } ]
WHERE carrier = '2M'
*/

describe table ascend_database.tar.nsm;

-- Reading
SELECT * FROM nsm LIMIT 10;

SELECT {*} FROM nsm LIMIT 1;

SELECT {* EXCLUDE automated_check_in} FROM nsm LIMIT 1;

SELECT {* EXCLUDE (automated_check_in, content_title)} FROM nsm LIMIT 1;

SELECT {* ILIKE 'CREAT%'} FROM nsm LIMIT 1;

SELECT airline_designator FROM nsm LIMIT 1;

SELECT airline_designator['carrier_code'] FROM nsm LIMIT 1;

SELECT airline_designator:carrier_code FROM nsm LIMIT 1;

SELECT airline_designator:travel_base_id AS id, airline_designator:carrier_code AS code FROM nsm LIMIT 1;

SELECT in_flight_service_info[0]['entertainment'][1] FROM nsm WHERE carrier = '2M' LIMIT 10;


-- drop table nsm;