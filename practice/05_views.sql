-- ============================================
-- HOTEL BOOKING PROJECT - VIEWS
-- Author: Maneesha
-- Date: August 2026
-- Description: Creating Standard, Secure and
--              Materialized views on Gold layer
--              for analyst access
-- ============================================

-- Set context
use database hotel_db;
use warehouse compute_wh;
use schema gold;

-- ============================================
-- STANDARD VIEWS
-- WHY: Saved queries that always show
--      fresh data. Analysts use these
--      instead of querying Gold tables
--      directly. Hides complexity!
-- ============================================

-- Standard View 1: Revenue by City
-- Business use: See which city makes most money
create or replace view gold.vw_revenue_by_city as
select * from gold.revenue_by_city;

-- Standard View 2: Bookings by Room Type
-- Business use: See most popular room types
create or replace view gold.vw_bookings_by_room_type as
select * from gold.bookings_by_room_type;

-- Standard View 3: Monthly Trends
-- Business use: See how bookings trend over time
create or replace view gold.vw_monthly_trends as
select * from gold.monthly_trends;


-- ============================================
-- SECURE VIEWS
-- WHY: Same as standard view but hides
--      the SQL definition from users!
--      Used when sharing sensitive
--      business logic or data with
--      external users or specific teams
-- ============================================

-- Secure View 1: High Value Bookings
-- Business use: Show only bookings above
-- average amount. Hides calculation logic!
create or replace secure view gold.vw_secure_high_value_bookings as
select
    booking_id,
    hotel_city,
    room_type,
    total_amount,
    booking_status
from silver.hotel_bookings
where total_amount > (
    select avg(total_amount)
    from silver.hotel_bookings
)
order by total_amount desc;

-- Secure View 2: Confirmed Bookings Only
-- Business use: Analysts only see confirmed
-- bookings. Cancellations hidden!
create or replace secure view gold.vw_secure_confirmed_bookings as
select
    booking_id,
    hotel_city,
    customer_name,
    check_in_date,
    check_out_date,
    room_type,
    total_amount
from silver.hotel_bookings
where booking_status = 'Confirmed';

-- ============================================
-- MATERIALIZED VIEW
-- WHY: Pre-calculates and STORES results!
--      Much faster than standard view
--      because results already calculated!
--      Best for heavy queries that run
--      many times daily by many analysts!
--
-- IMPORTANT: Only ONE materialized view
--            allowed per base table in
--            Snowflake!
--            Cannot use ORDER BY in
--            materialized views!
-- ============================================

-- Materialized View: Booking Summary by City
-- Business use: Dashboard showing city
-- performance. Runs 100s of times daily!
-- Pre-calculated = instant results! ✅
create or replace materialized view gold.vw_mat_city_summary as
select
    hotel_city,
    count(*) as total_bookings,
    sum(total_amount) as total_revenue,
    round(avg(total_amount), 2) as avg_booking_amount,
    count(case when booking_status = 'Confirmed'
          then 1 end) as confirmed_bookings,
    count(case when booking_status = 'Cancelled'
          then 1 end) as cancelled_bookings
from silver.hotel_bookings
group by hotel_city;

-- ============================================
-- VERIFY ALL VIEWS CREATED
-- ============================================

-- See all views in gold schema
show views in schema gold;

-- Query each view to confirm working!
select * from gold.vw_revenue_by_city;
select * from gold.vw_bookings_by_room_type;
select * from gold.vw_monthly_trends;
select * from gold.vw_secure_high_value_bookings;
select * from gold.vw_secure_confirmed_bookings;
select * from gold.vw_mat_city_summary;