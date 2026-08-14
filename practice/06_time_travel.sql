-- ============================================
-- HOTEL BOOKING PROJECT - TIME TRAVEL
-- Author: Maneesha
-- Date: August 2026
-- Description: Snowflake Time Travel
--              to recover accidentally deleted
--              or modified data
-- ============================================

-- Set context
use database hotel_db;
use warehouse compute_wh;
use schema silver;

-- ============================================
-- SCENARIO 1: Accidental DELETE
-- WHY: Shows how to recover deleted rows
--      using Time Travel offset
-- ============================================

-- Step 1: Check current row count before delete
select count(*) as before_delete
from silver.hotel_bookings;

-- Step 2: Accidentally delete confirmed bookings
delete from silver.hotel_bookings
where booking_status = 'Confirmed';

-- Step 3: Check row count after delete
-- Confirmed bookings are GONE! 😱
select count(*) as after_delete
from silver.hotel_bookings;

-- Step 4: See deleted data using Time Travel
-- Going back 300 seconds (5 minutes)
select count(*) as time_travel_count
from silver.hotel_bookings
at (offset => -300);

-- Step 5: Recover deleted rows!
insert into silver.hotel_bookings
select * from silver.hotel_bookings
at (offset => -300)
where booking_status = 'Confirmed';

-- Step 6: Verify data is back!
select count(*) as after_recovery
from silver.hotel_bookings;

-- ============================================
-- SCENARIO 2: Accidental DROP TABLE
-- WHY: Shows how to recover dropped table
--      using UNDROP command
-- ============================================

-- Step 1: Accidentally drop table! 😱
drop table silver.hotel_bookings;

-- Step 2: Try to query dropped table
-- This will fail!
-- select * from silver.hotel_bookings;

-- Step 3: Recover using UNDROP!
-- One command brings it back! ✅
undrop table silver.hotel_bookings;

-- Step 4: Verify table is back!
select count(*) from silver.hotel_bookings;

-- ============================================
-- SCENARIO 3: See historical data
-- WHY: Compare data before and after changes
-- ============================================

-- See data as it was 10 minutes ago
select * from silver.hotel_bookings
at (offset => -600)
limit 10;

-- Compare current vs 5 minutes ago
select
    current.booking_status,
    count(*) as current_count
from silver.hotel_bookings as current
group by booking_status;