-- ============================================
-- HOTEL BOOKING PROJECT - SILVER LAYER
-- Author: Maneesha
-- Date: August 2026
-- Description: Clean and validate bronze data
--              Apply proper data types
--              Fix data quality issues
--              Store clean data in silver table
-- ============================================

-- Set context
use database hotel_db;
use warehouse compute_wh;
use schema silver;

-- Step 1: Create silver table with proper data types
create or replace table silver.hotel_bookings (
    booking_id varchar,
    hotel_id integer,
    hotel_city varchar,
    customer_id varchar,
    customer_name varchar,
    customer_email varchar,
    check_in_date date,
    check_out_date date,
    room_type varchar,
    num_guests integer,
    total_amount decimal(10,2),
    currency varchar,
    booking_status varchar
);

-- Step 2: Insert cleaned data from bronze to silver
-- Applying all data quality fixes here
insert into silver.hotel_bookings
select

    booking_id,
    try_to_number(hotel_id) as hotel_id,
    initcap(trim(hotel_city)) as hotel_city,
    customer_id,
    initcap(trim(customer_name)) as customer_name,
    case
        when lower(trim(customer_email)) like '%@%.%' then lower(trim(customer_email))
        else null
    end as customer_email,
    try_to_date(null_if(check_in_date,'')) as check_in_date,
    try_to_date(null_if(check_out_date,'')) as check_out_date,
    initcap(trim(room_type)) as room_type,
    try_to_number(num_guests) as num_guests,
    ABS(try_to_number(total_amount)) as total_amount,
    upper(trim(currency)) as currency,
    case
        when upper(trim(booking_status))
             in ('CONFIRMED', 'CONFIRMEEED')
        then 'Confirmed'
        when upper(trim(booking_status))
             in ('CANCELLED', 'CANCELED')
        then 'Cancelled'
        when upper(trim(booking_status))
             in ('NO-SHOW', 'NOSHOW')
        then 'No-Show'
        else null
    end as booking_status

from bronze.hotel_bookings
where booking_id is not null
and try_to_date(check_in_date) is not null
and try_to_date(check_out_date) is not null
and try_to_date(check_in_date)
    <= try_to_date(check_out_date);

-- Step 3: Verify row count
-- Should be less than bronze due to bad rows filtered!
select count(*) from silver.hotel_bookings;

-- Step 4: Verify no negative amounts
-- Should return 0 rows!
select * from silver.hotel_bookings
where total_amount < 0;

-- Step 5: Verify no invalid emails
select count(*) as invalid_emails
from silver.hotel_bookings
where customer_email is null;

-- Step 6: Verify no invalid dates
select count(*) as invalid_dates
from silver.hotel_bookings
where check_in_date is null;