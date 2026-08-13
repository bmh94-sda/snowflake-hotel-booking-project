-- ============================================
-- HOTEL BOOKING PROJECT - SETUP
-- Author: Maneesha
-- Date: August 2026
-- Description: Initial setup for hotel booking
--              data pipeline using Medallion
--              Architecture (Bronze/Silver/Gold)
-- ============================================

-- Step 1: Create database
create database if not exists hotel_db;

-- Step 2: Use database
use database hotel_db;

-- Step 3: Use warehouse
use warehouse compute_wh;

-- Step 4: Create schemas for medallion architecture
-- bronze = raw data as received
-- silver = cleaned and validated
-- gold   = business ready reports
create schema if not exists bronze;
create schema if not exists silver;
create schema if not exists gold;

-- Step 5: Create file format for CSV files
create or replace file format hotel_db.bronze.csv_file_format
    type = 'CSV'
    field_optionally_enclosed_by = '"'
    skip_header = 1
    null_if = ('NULL','null','','N/A','NA','n/a','na')
    trim_space = true
    date_format = 'AUTO'
    timestamp_format = 'AUTO'
    error_on_column_count_mismatch = false;

-- Step 6: Create stage for loading files
create or replace stage hotel_db.bronze.stg_hotel_bookings
    file_format = hotel_db.bronze.csv_file_format;