-- CUICHAT / CUIChatter
-- Add users.university_card_image column (safe / no data loss)
-- Run this in Hostinger phpMyAdmin after selecting the database (e.g., u968840278_cuichat_db)
-- IMPORTANT: This script does NOT use "USE ..." and does NOT drop/truncate/delete any data.

SET @db := DATABASE();
SET @tbl := 'users';
SET @col := 'university_card_image';

SELECT COUNT(*) INTO @col_exists
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = @db
  AND TABLE_NAME = @tbl
  AND COLUMN_NAME = @col;

SET @sql := IF(
  @col_exists = 0,
  'ALTER TABLE `users` ADD COLUMN `university_card_image` VARCHAR(500) NULL AFTER `profile`;',
  'SELECT \"Column university_card_image already exists on users.\" AS message;'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT 'OK: university_card_image column ensured on users table.' AS message;

