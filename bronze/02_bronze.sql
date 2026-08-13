-- ============================================
-- HOTEL BOOKING PROJECT - BRONZE LAYER
-- Author: Maneesha
-- Date: August 2026
-- Description: Load raw CSV data into bronze
--              table exactly as received.
--              No transformations applied!
-- ============================================

-- Set context
use database hotel_db;
use warehouse compute_wh;
use schema bronze;

-- Step 1: Create bronze table
-- All columns as varchar to accept any data
-- Data types will be applied in silver layer
create or replace table bronze.hotel_bookings (
    booking_id varchar,
    hotel_id varchar,
    hotel_city varchar,
    customer_id varchar,
    customer_name varchar,
    customer_email varchar,
    check_in_date varchar,
    check_out_date varchar,
    room_type varchar,
    num_guests varchar,
    total_amount varchar,
    currency varchar,
    booking_status varchar
);

-- Step 2: Load raw data from stage into bronze table
-- on_error = continue means skip bad rows
-- and continue loading rest of data
copy into bronze.hotel_bookings
from @bronze.stg_hotel_bookings
on_error = 'CONTINUE';

-- Step 3: Verify data loaded correctly
-- Row count should match CSV file!
select count(*) from bronze.hotel_bookings;

-- Step 4: Quick look at loaded data
select * from bronze.hotel_bookings limit 10;

-- Step 5: Check for any loading errors
select * from table(validate(
    bronze.hotel_bookings,
    job_id => '_last'
));