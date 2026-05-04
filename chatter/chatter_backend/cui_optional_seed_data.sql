-- ============================================================================
-- Optional seed data for CUI / COMSATS registration
-- File: cui_optional_seed_data.sql
--
-- IMPORTANT:
-- 1) This file is optional.
-- 2) It does NOT create or delete any tables.
-- 3) It is meant only for reference or safe inserts if you decide to use them.
-- 4) Take a database backup before running any seed file.
--
-- Note:
-- - Departments and campuses are hardcoded in the Laravel registration flow,
--   so no separate departments/campuses table is required for the current app.
-- - Interests are also usually managed through the existing `interests` table.
-- ============================================================================

USE `u968840278_cuichat_db`;

-- ---------------------------------------------------------------------------
-- Optional: sample interest seeds
-- Uncomment ONLY if the `interests` table is empty and you want starter data.
-- Use INSERT IGNORE so duplicate titles do not cause a failure.
-- ---------------------------------------------------------------------------

-- INSERT IGNORE INTO `interests` (`title`, `created_at`, `updated_at`) VALUES
-- ('Technology', NOW(), NOW()),
-- ('Sports', NOW(), NOW()),
-- ('Music', NOW(), NOW()),
-- ('Art', NOW(), NOW()),
-- ('Gaming', NOW(), NOW()),
-- ('Travel', NOW(), NOW()),
-- ('Food', NOW(), NOW()),
-- ('Fashion', NOW(), NOW()),
-- ('Photography', NOW(), NOW()),
-- ('Fitness', NOW(), NOW());

-- ---------------------------------------------------------------------------
-- Optional reference only: CUI campus/departments used by the app UI
-- No SQL needed unless you later normalize these into lookup tables.
-- ---------------------------------------------------------------------------
-- Campuses used in the app:
--   - COMSATS University Islamabad
--   - Islamabad
--   - Lahore
--   - Abbottabad
--   - Wah
--   - Attock
--   - Sahiwal
--   - Vehari
--
-- Departments used in the app:
--   - Computer Science
--   - Software Engineering
--   - Artificial Intelligence
--   - Cyber Security
--   - Electrical Engineering
--   - Computer Engineering
--   - Management Sciences
--   - Mathematics
--   - Physics
--   - Humanities
-- ---------------------------------------------------------------------------

SELECT 'Optional seed file loaded. Nothing was changed unless you uncommented INSERT statements.' AS Result;
