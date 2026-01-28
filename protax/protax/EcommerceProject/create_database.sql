-- Quick script to create database and run schema
-- Run this with: psql -U postgres -f create_database.sql

-- Create database if it doesn't exist
SELECT 'CREATE DATABASE ecommerce'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'ecommerce')\gexec

-- Connect to the new database
\c ecommerce

-- Now run the schema script
\i database_schema_postgresql.sql
