-- Insert sample interests into the database
-- Run this SQL in your phpMyAdmin (localhost/phpmyadmin) or MySQL client
-- 1. Open phpMyAdmin
-- 2. Select 'chatter' database from left sidebar
-- 3. Click 'SQL' tab at top
-- 4. Paste this entire SQL and click 'Go'

USE chatter;

-- Clear existing interests (optional - comment out if you want to keep existing)
-- TRUNCATE TABLE interests;

-- Insert sample interests
INSERT INTO interests (title, created_at, updated_at) VALUES
('Technology', NOW(), NOW()),
('Sports', NOW(), NOW()),
('Music', NOW(), NOW()),
('Art', NOW(), NOW()),
('Gaming', NOW(), NOW()),
('Travel', NOW(), NOW()),
('Food', NOW(), NOW()),
('Fashion', NOW(), NOW()),
('Photography', NOW(), NOW()),
('Fitness', NOW(), NOW()),
('Movies', NOW(), NOW()),
('Books', NOW(), NOW()),
('Business', NOW(), NOW()),
('Science', NOW(), NOW()),
('Education', NOW(), NOW()),
('Politics', NOW(), NOW()),
('News', NOW(), NOW()),
('Comedy', NOW(), NOW()),
('Cooking', NOW(), NOW()),
('Health', NOW(), NOW());

-- Insert document types for profile verification
INSERT INTO document_types (title, created_at, updated_at) VALUES
('National ID', NOW(), NOW()),
('Passport', NOW(), NOW()),
('Driving License', NOW(), NOW());

-- Insert report reasons
INSERT INTO report_reasons (title, created_at, updated_at) VALUES
('Spam', NOW(), NOW()),
('Harassment', NOW(), NOW()),
('Hate Speech', NOW(), NOW()),
('Violence', NOW(), NOW()),
('False Information', NOW(), NOW()),
('Nudity or Sexual Content', NOW(), NOW()),
('Other', NOW(), NOW());

-- Create default global settings if not exists
INSERT INTO global_settings (
    app_name,
    google_login,
    apple_login,
    email_login,
    is_show_ads,
    interstitial_ad_show,
    banner_ad_show,
    revenue_cat_enable,
    created_at,
    updated_at
) VALUES (
    'Chatter',
    1,
    1,
    1,
    0,
    5,
    1,
    0,
    NOW(),
    NOW()
) ON DUPLICATE KEY UPDATE app_name = 'Chatter';

SELECT 'Database populated successfully!' AS Result;
