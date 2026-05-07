-- ============================================================
-- CUI Registration - Add Missing Columns to users table
-- HOW TO USE IN phpMyAdmin:
--   1. Copy ONE statement at a time (between the dashes)
--   2. Paste into the SQL tab and click Go
--   3. If it says "Duplicate column name" → that column already
--      exists, which is fine. Move to the next one.
--   4. If it says "Query OK" → column was added successfully.
-- ============================================================

-- STEP 1: Add email column
ALTER TABLE `users` ADD COLUMN `email` VARCHAR(255) NULL AFTER `identity`;

-- STEP 2: Add password column
ALTER TABLE `users` ADD COLUMN `password` VARCHAR(255) NULL AFTER `email`;

-- STEP 3: Add device_token column
ALTER TABLE `users` ADD COLUMN `device_token` VARCHAR(255) NULL;

-- STEP 4: Add is_block column
ALTER TABLE `users` ADD COLUMN `is_block` TINYINT(1) NOT NULL DEFAULT 0;

-- STEP 5: Add is_verified column
ALTER TABLE `users` ADD COLUMN `is_verified` TINYINT(1) NOT NULL DEFAULT 0;

-- STEP 6: Add interest_ids column
ALTER TABLE `users` ADD COLUMN `interest_ids` TEXT NULL;

-- STEP 7: Add background_image column
ALTER TABLE `users` ADD COLUMN `background_image` VARCHAR(255) NULL;

-- STEP 8: Add is_push_notifications column
ALTER TABLE `users` ADD COLUMN `is_push_notifications` TINYINT(1) NOT NULL DEFAULT 1;

-- STEP 9: Add is_invited_to_room column
ALTER TABLE `users` ADD COLUMN `is_invited_to_room` TINYINT(1) NOT NULL DEFAULT 1;

-- STEP 10: Add block_user_ids column
ALTER TABLE `users` ADD COLUMN `block_user_ids` TEXT NULL;

-- STEP 11: Add saved_music_ids column
ALTER TABLE `users` ADD COLUMN `saved_music_ids` TEXT NULL;

-- STEP 12: Add saved_reel_ids column
ALTER TABLE `users` ADD COLUMN `saved_reel_ids` TEXT NULL;

-- STEP 13: Add is_moderator column
ALTER TABLE `users` ADD COLUMN `is_moderator` TINYINT(1) NOT NULL DEFAULT 0;

-- STEP 14: Add role_type column
ALTER TABLE `users` ADD COLUMN `role_type` VARCHAR(20) NULL;

-- STEP 15: Add approval_status column
ALTER TABLE `users` ADD COLUMN `approval_status` VARCHAR(20) NULL DEFAULT 'pending';

-- STEP 16: Add registration_number column
ALTER TABLE `users` ADD COLUMN `registration_number` VARCHAR(255) NULL;

-- STEP 17: Add department column
ALTER TABLE `users` ADD COLUMN `department` VARCHAR(255) NULL;

-- STEP 18: Add batch_duration column
ALTER TABLE `users` ADD COLUMN `batch_duration` VARCHAR(255) NULL;

-- STEP 19: Add phone_number column
ALTER TABLE `users` ADD COLUMN `phone_number` VARCHAR(255) NULL;

-- STEP 20: Add gender column
ALTER TABLE `users` ADD COLUMN `gender` VARCHAR(20) NULL;

-- STEP 21: Add campus column
ALTER TABLE `users` ADD COLUMN `campus` VARCHAR(255) NULL DEFAULT 'Islamabad';

-- STEP 22: Add phone_verified_at column
ALTER TABLE `users` ADD COLUMN `phone_verified_at` DATETIME NULL;

-- STEP 23: Add approved_at column
ALTER TABLE `users` ADD COLUMN `approved_at` DATETIME NULL;

-- STEP 24: Add approved_by column
ALTER TABLE `users` ADD COLUMN `approved_by` BIGINT UNSIGNED NULL;

-- STEP 25: Add rejected_reason column
ALTER TABLE `users` ADD COLUMN `rejected_reason` TEXT NULL;

-- STEP 26: Add email_verified_or_approval_sent_at column
ALTER TABLE `users` ADD COLUMN `email_verified_or_approval_sent_at` DATETIME NULL;

-- STEP 27: Set approval_status = 'approved' for all existing users
-- (so existing social-login users are not blocked)
UPDATE `users` SET `approval_status` = 'approved' WHERE `approval_status` IS NULL;

-- STEP 28: Create registration_otps table (safe - only creates if not exists)
CREATE TABLE IF NOT EXISTS `registration_otps` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `phone_number` VARCHAR(255) NOT NULL,
    `otp_code` VARCHAR(255) NOT NULL,
    `otp_expires_at` DATETIME NOT NULL,
    `verified_at` DATETIME NULL DEFAULT NULL,
    `consumed_at` DATETIME NULL DEFAULT NULL,
    `created_at` DATETIME NULL DEFAULT NULL,
    `updated_at` DATETIME NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `reg_otps_phone_unique` (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
