-- ============================================
-- HOTEL BOOKING PROJECT - GOLD LAYER
-- Author: Maneesha
-- Date: August 2026
-- Description: Business ready aggregated tables
--              built from clean silver data
--              Used for reporting and dashboards
-- ============================================

-- Set context
use database hotel_db;
use warehouse compute_wh;
use schema gold;

-- ============================================
-- GOLD TABLE 1: Revenue by City
-- Business question: Which city generates
--                   most revenue?
-- ============================================
create or replace table gold.revenue_by_city as
select
    hotel_city,
    count(*) as total_bookings,
    sum(total_amount) as total_revenue,
    round(avg(total_amount), 2) as avg_booking_amount
from silver.hotel_bookings
group by hotel_city
order by total_revenue desc;

-- ============================================
-- GOLD TABLE 2: Bookings by Room Type
-- Business question: Which room type is
--                   most popular?
-- ============================================
create or replace table gold.bookings_by_room_type as
select
    room_type,
    count(*) as total_bookings,
    sum(total_amount) as total_revenue,
    round(avg(total_amount), 2) as avg_amount
from silver.hotel_bookings
group by room_type
order by total_bookings desc;

-- ============================================
-- GOLD TABLE 3: Booking Status Summary
-- Business question: How many bookings
--                   confirmed vs cancelled?
-- ============================================
create or replace table gold.booking_status_summary as
select
    booking_status,
    count(*) as total_bookings,
    round(count(*) * 100.0 /
        sum(count(*)) over(), 2) as percentage
from silver.hotel_bookings
group by booking_status
order by total_bookings desc;

-- ============================================
-- GOLD TABLE 4: Revenue by Currency
-- Business question: Which currency
--                   generates most revenue?
-- ============================================
create or replace table gold.revenue_by_currency as
select
    currency,
    count(*) as total_bookings,
    sum(total_amount) as total_revenue,
    round(avg(total_amount), 2) as avg_amount
from silver.hotel_bookings
group by currency
order by total_revenue desc;

-- ============================================
-- GOLD TABLE 5: Monthly Booking Trends
-- Business question: How do bookings
--                   trend over months?
-- ============================================
create or replace table gold.monthly_trends as
select
    date_trunc('month', check_in_date) as booking_month,
    count(*) as total_bookings,
    sum(total_amount) as total_revenue,
    round(avg(total_amount), 2) as avg_amount
from silver.hotel_bookings
group by booking_month
order by booking_month asc;

-- Verify all gold tables created successfully
select * from gold.revenue_by_city limit 5;
select * from gold.bookings_by_room_type limit 5;
select * from gold.booking_status_summary;
select * from gold.revenue_by_currency;
select * from gold.monthly_trends limit 5;