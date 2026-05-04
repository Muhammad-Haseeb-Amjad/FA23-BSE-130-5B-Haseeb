-- ============================================================================
-- CUI / COMSATS registration database update
-- File: cui_registration_update.sql
--
-- IMPORTANT:
-- 1) Take a full database backup before running this file.
-- 2) This script is DESIGNED to be non-destructive.
-- 3) It does NOT drop tables, truncate data, or delete existing rows.
-- 4) It only adds missing columns/indexes and updates NULL/empty legacy values.
--
-- Target database: `u968840278_cuichat_db`
-- Run order:
--   a) Backup database
--   b) Run this file in phpMyAdmin
--   c) Verify the checklist at the end of this response
--
-- Compatibility note:
--   This file avoids relying on ALTER TABLE ... ADD COLUMN IF NOT EXISTS,
--   so it is safer for shared hosting / Hostinger environments.
-- ============================================================================

USE `u968840278_cuichat_db`;

SET @schema_name := DATABASE();

-- ---------------------------------------------------------------------------
-- 1) users table: add missing CUI registration columns (if they do not exist)
-- ---------------------------------------------------------------------------

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `email` VARCHAR(255) NULL AFTER `identity`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'email'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `role_type` VARCHAR(20) NULL AFTER `full_name`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'role_type'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `approval_status` VARCHAR(20) NULL DEFAULT ''pending'' AFTER `role_type`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'approval_status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `registration_number` VARCHAR(255) NULL AFTER `approval_status`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'registration_number'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `department` VARCHAR(255) NULL AFTER `registration_number`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'department'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `batch_duration` VARCHAR(255) NULL AFTER `department`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'batch_duration'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `phone_number` VARCHAR(255) NULL AFTER `batch_duration`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'phone_number'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `gender` VARCHAR(20) NULL AFTER `phone_number`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'gender'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `campus` VARCHAR(255) NULL DEFAULT ''Islamabad'' AFTER `gender`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'campus'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `phone_verified_at` DATETIME NULL AFTER `campus`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'phone_verified_at'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `otp_code` VARCHAR(255) NULL AFTER `phone_verified_at`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'otp_code'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `otp_expires_at` DATETIME NULL AFTER `otp_code`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'otp_expires_at'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `approved_at` DATETIME NULL AFTER `otp_expires_at`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'approved_at'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `approved_by` BIGINT UNSIGNED NULL AFTER `approved_at`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'approved_by'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `rejected_reason` TEXT NULL AFTER `approved_by`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'rejected_reason'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD COLUMN `email_verified_or_approval_sent_at` DATETIME NULL AFTER `rejected_reason`',
        'SELECT 1'
    )
    FROM information_schema.columns
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'email_verified_or_approval_sent_at'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------------------------------------------------------------------------
-- 2) users table: add useful indexes safely
--    NOTE: We do not force UNIQUE here to avoid failing on legacy duplicates.
-- ---------------------------------------------------------------------------

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD INDEX `idx_users_role_type` (`role_type`)',
        'SELECT 1'
    )
    FROM information_schema.statistics
    WHERE table_schema = @schema_name
      AND table_name = 'users'
      AND column_name = 'role_type'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD INDEX `idx_users_approval_status` (`approval_status`)',
        'SELECT 1'
    )
    FROM information_schema.statistics
    WHERE table_schema = @schema_name
      AND table_name = 'users'
            AND column_name = 'approval_status'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD INDEX `idx_users_registration_number` (`registration_number`)',
        'SELECT 1'
    )
    FROM information_schema.statistics
    WHERE table_schema = @schema_name
      AND table_name = 'users'
            AND column_name = 'registration_number'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD INDEX `idx_users_phone_number` (`phone_number`)',
        'SELECT 1'
    )
    FROM information_schema.statistics
    WHERE table_schema = @schema_name
      AND table_name = 'users'
            AND column_name = 'phone_number'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD INDEX `idx_users_email` (`email`)',
        'SELECT 1'
    )
    FROM information_schema.statistics
    WHERE table_schema = @schema_name
      AND table_name = 'users'
            AND column_name = 'email'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD INDEX `idx_users_campus` (`campus`)',
        'SELECT 1'
    )
    FROM information_schema.statistics
    WHERE table_schema = @schema_name
      AND table_name = 'users'
            AND column_name = 'campus'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `users` ADD INDEX `idx_users_department` (`department`)',
        'SELECT 1'
    )
    FROM information_schema.statistics
    WHERE table_schema = @schema_name
      AND table_name = 'users'
            AND column_name = 'department'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------------------------------------------------------------------------
-- 3) users table: normalize legacy values for compatibility
-- ---------------------------------------------------------------------------

UPDATE `users`
SET `email` = `identity`
WHERE (`email` IS NULL OR TRIM(`email`) = '')
    AND `identity` IS NOT NULL
    AND TRIM(`identity`) <> '';

UPDATE `users`
SET `approval_status` = 'approved'
WHERE `approval_status` IS NULL OR TRIM(`approval_status`) = '';

UPDATE `users`
SET `campus` = 'Islamabad'
WHERE `campus` IS NULL OR TRIM(`campus`) = '';

-- Optional: If your old live rows should also have timestamps for audit clarity,
-- you can uncomment the following line. It is commented out by default to avoid
-- modifying existing approved records beyond the requested compatibility update.
-- UPDATE `users` SET `approved_at` = COALESCE(`approved_at`, NOW()) WHERE `approval_status` = 'approved' AND `approved_at` IS NULL;

-- ---------------------------------------------------------------------------
-- 4) OTP support: separate table used by the CUI registration flow
-- ---------------------------------------------------------------------------

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
    UNIQUE KEY `registration_otps_phone_number_unique` (`phone_number`),
    KEY `registration_otps_otp_expires_at_index` (`otp_expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 5) Admin approval workflow
-- ---------------------------------------------------------------------------
-- No extra table is required for approvals/rejections/cancellations.
-- The existing `users.approval_status` / `approved_at` / `approved_by` /
-- `rejected_reason` columns are enough for the current workflow.
-- ---------------------------------------------------------------------------

SELECT 'CUI registration database update completed successfully.' AS Result;
