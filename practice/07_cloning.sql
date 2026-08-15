-- ============================================
-- HOTEL BOOKING PROJECT - CLONING
-- Author: Maneesha
-- Date: August 2026
-- Description: Snowflake Cloning
--              to safely test without touching
--              production data
-- ============================================

-- Set context
use database hotel_db;
use warehouse compute_wh;

-- ============================================
-- SCENARIO 1: Clone a Table
-- WHY: Test changes safely without
--      touching original table!
-- ============================================

-- Step 1: Check original table count
select count(*) as original_count
from silver.hotel_bookings;

-- Step 2: Clone silver table instantly
-- Zero cost! Zero time! ✅
create or replace table silver.hotel_bookings_clone
clone silver.hotel_bookings;

-- Step 3: Verify clone has same data
select count(*) as clone_count
from silver.hotel_bookings_clone;

-- Step 4: Modify clone safely
-- Original stays untouched!
delete from silver.hotel_bookings_clone
where booking_status = 'Cancelled';

-- Step 5: Clone affected, original safe!
select count(*) as clone_after_delete
from silver.hotel_bookings_clone;

select count(*) as original_still_safe
from silver.hotel_bookings;

-- Step 6: Drop clone when done
drop table silver.hotel_bookings_clone;

-- ============================================
-- SCENARIO 2: Clone a Schema
-- WHY: Create complete copy of entire
--      schema for testing!
-- ============================================

-- Clone entire silver schema!
create or replace schema hotel_db.silver_clone
clone hotel_db.silver;

-- Verify all tables cloned!
show tables in schema hotel_db.silver_clone;

-- Query cloned table
select count(*) 
from hotel_db.silver_clone.hotel_bookings;

-- Drop clone schema when done
drop schema hotel_db.silver_clone;

-- ============================================
-- SCENARIO 3: Clone a Database
-- WHY: Create complete copy of entire
--      database for testing!
--      Most powerful cloning option!
-- ============================================

-- Clone entire hotel_db!
create or replace database hotel_db_clone
clone hotel_db;

-- Verify clone exists
show databases like 'hotel_db_clone';

-- Drop clone when done
drop database hotel_db_clone;