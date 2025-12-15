-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 30, 2025 at 02:40 PM
-- Server version: 8.0.43-0ubuntu0.22.04.1
-- PHP Version: 8.1.2-1ubuntu2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `empty_chatter`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` bigint UNSIGNED NOT NULL,
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_type` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `user_name`, `user_password`, `user_type`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin123', 1, '2023-03-23 05:42:36', '2023-08-14 02:31:00'),
(2, 'tester', 'tester@123', 0, '2023-03-23 05:42:22', '2023-03-23 05:42:22');

-- --------------------------------------------------------

--
-- Table structure for table `admin_notifications`
--

CREATE TABLE `admin_notifications` (
  `id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int NOT NULL,
  `post_id` int NOT NULL,
  `desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `document_types`
--

CREATE TABLE `document_types` (
  `id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `faqs`
--

CREATE TABLE `faqs` (
  `id` int NOT NULL,
  `faqs_type_id` int NOT NULL,
  `question` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `faqs_types`
--

CREATE TABLE `faqs_types` (
  `id` int NOT NULL,
  `title` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_deleted` int NOT NULL DEFAULT '0' COMMENT '0 = No / 1 = Yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `following_lists`
--

CREATE TABLE `following_lists` (
  `id` bigint UNSIGNED NOT NULL,
  `my_user_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `interests`
--

CREATE TABLE `interests` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int NOT NULL,
  `post_id` int DEFAULT NULL,
  `reel_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `like_comments`
--

CREATE TABLE `like_comments` (
  `id` int NOT NULL,
  `comment_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(115, '2023_03_13_104802_create_follower_lists_table', 22),
(197, '2023_03_10_131243_create_admins_table', 23),
(198, '2023_03_11_070705_create_interests_table', 23),
(199, '2023_03_13_101549_create_following_lists_table', 23),
(200, '2023_03_14_071412_create_posts_table', 23),
(201, '2023_03_14_095829_create_post_contents_table', 23),
(202, '2023_03_14_112354_create_comments_table', 23),
(203, '2023_03_14_123122_create_likes_table', 23),
(233, '2014_10_12_100000_create_password_resets_table', 24),
(234, '2019_08_19_000000_create_failed_jobs_table', 24),
(235, '2019_12_14_000001_create_personal_access_tokens_table', 24),
(236, '2023_03_14_133316_create_admins_table', 24),
(240, '2023_03_15_053621_create_following_lists_table', 25),
(241, '2023_03_15_062628_create_posts_table', 26),
(242, '2023_03_15_063546_create_post_contents_table', 27),
(243, '2023_03_15_065627_create_comments_table', 28),
(245, '2023_03_15_074058_create_likes_table', 29),
(276, '2014_10_12_000000_create_users_table', 38),
(277, '2023_03_20_072719_create_report_rooms_table', 39),
(279, '2023_03_15_103222_create_rooms_table', 41),
(281, '2023_03_16_135209_create_room_data_table', 42),
(282, '2023_03_20_073418_create_reports_table', 43);

-- --------------------------------------------------------

--
-- Table structure for table `musics`
--

CREATE TABLE `musics` (
  `id` int NOT NULL,
  `category_id` int DEFAULT NULL,
  `title` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sound` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `duration` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `artist` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image` varchar(999) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=not 1=deleted',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `music_categories`
--

CREATE TABLE `music_categories` (
  `id` int NOT NULL,
  `title` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_deleted` int NOT NULL DEFAULT '0' COMMENT '0 = No / 1 = Yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int NOT NULL,
  `desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `comments_count` int DEFAULT '0',
  `likes_count` int DEFAULT '0',
  `link_preview_json` varchar(900) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `interest_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_restricted` int NOT NULL DEFAULT '0' COMMENT '0 = Off / 1 = On (restricted)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `post_contents`
--

CREATE TABLE `post_contents` (
  `id` bigint UNSIGNED NOT NULL,
  `post_id` int NOT NULL,
  `content_type` int NOT NULL COMMENT 'image = 0, video = 1, Audio = 2',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `audio_waves` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `profile_verifications`
--

CREATE TABLE `profile_verifications` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int NOT NULL,
  `selfie` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `document` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `document_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reels`
--

CREATE TABLE `reels` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `interest_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `music_id` int DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hashtags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `comments_count` int NOT NULL DEFAULT '0',
  `likes_count` int NOT NULL DEFAULT '0',
  `views_count` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reel_comments`
--

CREATE TABLE `reel_comments` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `reel_id` int NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` bigint UNSIGNED NOT NULL,
  `type` int DEFAULT NULL COMMENT '0 = Room Report, 1 = Post Report, 2 = User Report, 3 = Reel Report',
  `room_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `post_id` int DEFAULT NULL,
  `reel_id` int DEFAULT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report_reasons`
--

CREATE TABLE `report_reasons` (
  `id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` bigint UNSIGNED NOT NULL,
  `admin_id` int NOT NULL,
  `photo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `desc` varchar(900) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `interest_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_private` int NOT NULL,
  `is_join_request_enable` int NOT NULL,
  `total_member` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_users`
--

CREATE TABLE `room_users` (
  `id` int NOT NULL,
  `room_id` int NOT NULL,
  `user_id` int NOT NULL,
  `invited_by` int DEFAULT NULL,
  `type` int NOT NULL COMMENT '1 = Request for Join| 2 = Accept - member | 3 = co-Admin | 4 = Invited | 5 = Admin',
  `is_mute` int NOT NULL DEFAULT '0' COMMENT '0 = unmute / 1 = Mute',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `saved_notifications`
--

CREATE TABLE `saved_notifications` (
  `id` int NOT NULL,
  `my_user_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `post_id` int DEFAULT NULL,
  `room_id` int DEFAULT NULL,
  `comment_id` int DEFAULT NULL,
  `reel_id` int DEFAULT NULL,
  `reel_comment_id` int DEFAULT NULL,
  `type` int NOT NULL COMMENT '1 = Follow, 2 = Comment, 3 = Post Like, 4 = Invite Room, 5 = Accept Invitation Room (User), 6 = join Room, 7 = DIrect Join Room, 8 = Accept Room Request (Admin), 9 = Reel Like, 10 = Add Reel Comment',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint UNSIGNED NOT NULL,
  `app_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `setRoomUsersLimit` int NOT NULL,
  `minute_limit_in_creating_story` int DEFAULT NULL,
  `minute_limit_in_audio_post` int DEFAULT NULL,
  `minute_limit_in_choosing_video_for_story` int DEFAULT NULL,
  `minute_limit_in_choosing_video_for_post` int DEFAULT NULL,
  `max_images_can_be_uploaded_in_one_post` int DEFAULT NULL,
  `ad_banner_android` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ad_interstitial_android` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ad_banner_iOS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ad_interstitial_iOS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_admob_on` int NOT NULL DEFAULT '1' COMMENT '0 = off / 1 = on',
  `audio_space_hosts_limit` bigint NOT NULL,
  `audio_space_listeners_limit` bigint NOT NULL,
  `audio_space_duration_in_minutes` bigint NOT NULL,
  `duration_limit_in_reel` int NOT NULL DEFAULT '60',
  `is_sight_engine_enabled` int NOT NULL DEFAULT '0',
  `sight_engine_api_user` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sight_engine_api_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sight_engine_image_workflow_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sight_engine_video_workflow_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `storage_type` int NOT NULL DEFAULT '0' COMMENT '0 = Local / 1 = AWS S3 / 2 = DigitaoOcean Space	',
  `fetch_post_type` int NOT NULL DEFAULT '0' COMMENT '0 = Random / 1 = Latest',
  `support_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_in_app_purchase_enabled` tinyint NOT NULL DEFAULT '1' COMMENT '0 = Disabled / 1 = Enabled',
  `play_store_download_link` varchar(999) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `app_store_download_link` varchar(999) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uri_scheme` varchar(55) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `app_name`, `setRoomUsersLimit`, `minute_limit_in_creating_story`, `minute_limit_in_audio_post`, `minute_limit_in_choosing_video_for_story`, `minute_limit_in_choosing_video_for_post`, `max_images_can_be_uploaded_in_one_post`, `ad_banner_android`, `ad_interstitial_android`, `ad_banner_iOS`, `ad_interstitial_iOS`, `is_admob_on`, `audio_space_hosts_limit`, `audio_space_listeners_limit`, `audio_space_duration_in_minutes`, `duration_limit_in_reel`, `is_sight_engine_enabled`, `sight_engine_api_user`, `sight_engine_api_secret`, `sight_engine_image_workflow_id`, `sight_engine_video_workflow_id`, `storage_type`, `fetch_post_type`, `support_email`, `is_in_app_purchase_enabled`, `play_store_download_link`, `app_store_download_link`, `uri_scheme`, `created_at`, `updated_at`) VALUES
(1, 'Chatter.', 11, 2, 1, 1, 1, 4, '', '', '', '', 0, 234, 100, 110, 60, 0, NULL, NULL, NULL, NULL, 0, 1, 'admin@example.com', 0, NULL, NULL, NULL, '2023-03-04 09:43:26', '2025-03-20 04:36:04');

-- --------------------------------------------------------

--
-- Table structure for table `stories`
--

CREATE TABLE `stories` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `type` int NOT NULL DEFAULT '0' COMMENT '0 = Image, 1 = Video',
  `duration` double NOT NULL DEFAULT '0',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `view_by_user_ids` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pages`
--

CREATE TABLE `tbl_pages` (
  `id` int NOT NULL,
  `privacy` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `termsofuse` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pages`
--

INSERT INTO `tbl_pages` (`id`, `privacy`, `termsofuse`, `created_at`, `updated_at`) VALUES
(1, '<pre courier=\"\" new\",=\"\" monospace;=\"\" font-size:=\"\" 13px;=\"\" padding:=\"\" 9.5px;=\"\" margin-bottom:=\"\" 10px;=\"\" line-height:=\"\" 1.42857;=\"\" word-break:=\"\" break-all;=\"\" overflow-wrap:=\"\" break-word;=\"\" color:=\"\" rgb(51,=\"\" 51,=\"\" 51);=\"\" background-color:=\"\" rgb(245,=\"\" 245,=\"\" 245);=\"\" border:=\"\" 1px=\"\" solid=\"\" rgb(204,=\"\" 204,=\"\" 204);=\"\" border-radius:=\"\" 4px;\"=\"\" style=\"padding: 0px; font-family: var(--bs-font-monospace); direction: ltr; unicode-bidi: bidi-override; color: rgb(0, 0, 0); --darkreader-inline-color:#ffffff;\" data-darkreader-inline-color=\"\"><h1 style=\"padding: 0px; margin: 20px 0px; color: rgb(58, 72, 81); font-size: 36px; border: 0px; font-family: AR12; white-space: normal; --darkreader-inline-color:#e2dad1; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-color=\"\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><blockquote style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" class=\"blockquote\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"background-color: transparent; font-family: Scandia; font-size: 22px; text-align: var(--bs-body-text-align);\"><u>Privacy Policy</u></span><br></blockquote></h1><h1 style=\"padding: 0px; margin: 20px 0px; font-weight: normal; color: rgb(58, 72, 81); font-size: 36px; border: 0px; font-family: AR12; white-space: normal; --darkreader-inline-color:#e2dad1; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-color=\"\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Demos follows the relevant legal requirements and takes all reasonable precautions to safeguard personal information.</span></p><ol times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 3px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none decimal; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">INTRODUCTION</span></li></ol><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Demos is committed to protecting your privacy and security. This policy explains how and why we use your personal data, to ensure you remain informed and in control of your information.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">You can decide not to receive communications or c</span><span style=\"font-family: Scandia;\">﻿</span><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">hange how we contact you at any time. If you wish to do so please contact us by emailing&nbsp;hello@demos.co.uk, writing to 76 Vincent Square, London, SW1 2PD or 020 3878 3955 (Lines open 9.30am – 6pm, Mon – Fri).</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We will never sell your personal data, and will only ever share it with organisations we work with where necessary and if its privacy and security are guaranteed. Personal information submitted to Demos is only used to contact you regarding Demos activities.&nbsp;</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Information about visitors to the Demos website domain is automatically logged for the purposes of statistical analysis. Such information includes the IP address from which you visit, referral address, and other technical information such as browser type and operating system. Your email address is not automatically logged without your knowledge.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We will not distribute, sell, trade or rent your personal information to third parties. Demos may provide aggregate statistics about our website’s users, traffic patterns and related site information to reputable third-parties such as Demos’s funding bodies or potential partners. Such statistical information will not include personally identifying information.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Questions?</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Any questions you have in relation to this policy or how we use your personal data should be sent to&nbsp;hello@demos.co.uk&nbsp;for the attention of Demos’ Head of External Affairs.</span></p><ol times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 3px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none decimal; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">ABOUT US</span></li></ol><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Your personal data (i.e. any information which identifies you, or which can be identified as relating to you personally) will be collected and used by Demos (charity no:1042046,&nbsp; company registration no: 2977740).</span></p><ol times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 3px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none decimal; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">THE INFORMATION WE COLLECT</span></li></ol><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Personal data you provide</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We collect data you provide to us. This includes information you give when joining as a member or signing up to our newsletter, placing an order or communicating with us. For example:</span></p><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">personal details (name, job title, organisation and email) when you sign up to our newsletter and / or events.</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">financial information (payment information such as credit/debit card or direct debit details, when making donations or paying for a service. Please see section 8 for more information on payment security); and</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">details of Demos events you have attended.</span></li></ul><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Sensitive personal data</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We do not normally collect or store sensitive personal data (such as information relating to health, beliefs or political affiliation) about those signed up to Demos’s newsletter. However there are some situations where this will occur (e.g. if you have an accident on one of our events). If this does occur, we’ll take extra care to ensure your privacy rights are protected.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Accidents or incidents</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">If an accident or incident occurs on our property, at one of our events or involving one of our staff then we’ll keep a record of this (which may include personal data and sensitive personal data).</span></p><ol times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 3px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none decimal; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">HOW WE USE INFORMATION2222</span></li></ol><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We only ever use your personal data with your consent, or where it is necessary in order to:</span></p><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">enter into, or perform, a contract with you;</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">comply with a legal duty;</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">protect your vital interests;</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">for our own (or a third party’s) lawful interests, provided your rights don’t override these.</span></li></ul><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">In any event, we’ll only use your information for the purpose or purposes it was collected for (or else for closely related purposes).</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Administration</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We use personal data for administrative purposes (i.e. on our research and events programmes). This includes:</span></p><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">maintaining databases of those signed up to our newsletter;</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">fulfilling orders for goods or services (whether placed online, over the phone or in person);</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">helping us respect your choices and preferences (e.g. if you ask not to receive marketing material, we’ll keep a record of this).</span></li></ul><ol times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 3px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none decimal; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">DISCLOSING AND SHARING DATA</span></li></ol><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Your personal data – which may include your name, organisation, position, and email address are held by our mailing list provider. By signing up to our newsletter you are agreeing to the terms and conditions of MailChimp.com (</span><a href=\"https://mailchimp.com/legal/terms/\" style=\"padding: 0px; margin: 0px; color: rgb(14, 40, 42); text-decoration-line: none; border: 0px; outline: none; --darkreader-inline-color:#fffdf6; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-outline: initial;\" data-darkreader-inline-color=\"\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-outline=\"\"><span style=\"font-family: Scandia;\">http://mailchimp.com/legal/terms/</span></a><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">). This information is not shared with any other organisation. If you wish to unsubscribe from our mailing list at any time, you can do so by clicking the ‘unsubscribe’ link, found at the bottom of any email we send you – or by sending your name and email address to&nbsp;</span><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">hello@demos.co.uk</span><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">&nbsp;– stating ‘Unsubscribe’ in the email in the subject line or body of the email.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">If you register to attend an event, your personal data which may include your name, organisation, and email address are held by our event registration provider. By registering to attend an event you are agreeing to the terms and conditions of Eventbrite (</span><a href=\"https://www.eventbrite.com/l/LegalTerms/\" style=\"padding: 0px; margin: 0px; color: rgb(14, 40, 42); text-decoration-line: none; border: 0px; outline: none; --darkreader-inline-color:#fffdf6; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-outline: initial;\" data-darkreader-inline-color=\"\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-outline=\"\"><span style=\"font-family: Scandia;\">https://www.eventbrite.com/l/LegalTerms/</span></a><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">)</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Occasionally, where we partner with other organisations, we may also share information with them (for example, if you register to attend an event being jointly organised by us and another organisation). We’ll only share information when necessary and we will never share your contact information (e.g. email or telephone).</span></p><ol times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 3px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none decimal; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">MARKETING</span></li></ol><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Demos will ask for individuals to “opt-in” for most communications. This includes all our marketing communications (the term marketing is broadly defined and covers information shared in our newsletter.)</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We use personal data to communicate with people, to promote Demos and to help with fundraising activities. This includes keeping you up to date with information from Demos on our research, events, news, job opportunities and other information relating to our work.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">You can decide not to receive communications or change how we contact you at any time. If you wish to do so please contact us by emailing&nbsp;</span><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">hello@demos.co.uk,</span><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">&nbsp;writing to Demos, 76 Vincent Square, London SW1P 2PD or telephoning 020 3878 3955 (Lines open 9.30am – 6pm, Mon – Fri).</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">What does ‘marketing’ mean?</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Marketing does not just mean offering things for sale, but also includes news and information about:</span></p><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">our research programme, including details of recent reports or blogs;</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">our events and activities; and</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">job opportunities.</span></li></ul><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">When you receive a communication, we may collect information about how you respond to or interact with that communication, and this may affect how we communicate with you in future.</span></p><ol times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 3px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none decimal; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">HOW WE PROTECT DATA</span></li></ol><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We employ a variety of physical and technical measures to keep your data safe and to prevent unauthorised access to, or use or disclosure of your personal information.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Electronic data and databases are stored on secure computer systems and we control who has access to information (using both physical and electronic means). Our staff receive data protection training and we have a set of detailed data protection procedures which personnel are required to follow when handling personal data.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Payment security</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">All electronic Demos forms that request financial data use pass your details to our payment provider (Stripe Payments Europe:&nbsp;</span><a href=\"https://stripe.com/gb/privacy\" style=\"padding: 0px; margin: 0px; color: rgb(14, 40, 42); text-decoration-line: none; border: 0px; outline: none; --darkreader-inline-color:#fffdf6; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-outline: initial;\" data-darkreader-inline-color=\"\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-outline=\"\"><span style=\"font-family: Scandia;\">https://stripe.com/gb/privacy</span></a><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">;&nbsp;</span><a href=\"https://stripe.com/privacy-shield-policy\" style=\"padding: 0px; margin: 0px; color: rgb(14, 40, 42); text-decoration-line: none; border: 0px; outline: none; --darkreader-inline-color:#fffdf6; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-outline: initial;\" data-darkreader-inline-color=\"\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-outline=\"\"><span style=\"font-family: Scandia;\">https://stripe.com/privacy-shield-policy</span></a><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">). Demos complies with the payment card industry data security standard (PCI-DSS) published by the PCI Security Standards Council, and will never store card details. If you would rather make a payment through BACS or by cheque please contact us by emailing&nbsp;hello@demos.co.uk, writing to Unit 1, Lloyd’s Wharf, 2-3 Mill Street, London SE1 2BD or telephoning 020 3878 3955 (Lines open 9.30am – 6pm, Mon – Fri).</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Of course, we cannot guarantee the security of your home computer or the internet, and any online communications (e.g. information provided by email or our website) are at the user’s own risk.</span></p><ol times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 3px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none decimal; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">STORAGE</span></li></ol><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Where we store information</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Demos’ operations are based in England and we store our data within the European Union.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">How long we store information</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We will only use and store information for so long as it is required for the purposes it was collected for. How long information will be stored for depends on the information in question and what it is being used for. For example, if you ask us not to send you marketing emails, we will stop storing your emails for marketing purposes (though we’ll keep a record of your preference not to be emailed).</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We continually review what information we hold and delete what is no longer required. We never store payment card information.</span></p><ol times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 3px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none decimal; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">KEEPING YOU IN CONTROL</span></li></ol><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We want to ensure you remain in control of your personal data. Part of this is making sure you understand your legal rights, which are as follows:</span></p><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">the right to confirmation as to whether or not we have your personal data and, if we do, to obtain a copy of the personal information we hold (this is known as subject access request);</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">the right to have your data erased (though this will not apply where it is necessary for us to continue to use the data for a lawful reason);</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">the right to have inaccurate data rectified;</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">the right to object to your data being used for marketing or profiling; and</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">where technically feasible, you have the right to personal data you have provided to us which we process automatically on the basis of your consent or the performance of a contract. This information will be provided in a common electronic format.</span></li></ul><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Please keep in mind that there are exceptions to the rights above and, though we will always try to respond to your satisfaction, there may be situations where we are unable to do so.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">If you would like further information on your rights or wish to exercise them, please write to Demos’ Head of External Affairs, 76 Vincent Square, London, SW1P 2PD or by email;&nbsp;hello@demos.co.uk</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Complaints</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">You can complain to Demos directly by contacting our Head of External Affairs using the details set out above.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">If you are not happy with our response, or you believe that your data protection or privacy rights have been infringed, you can complain to the UK Information Commissioner’s Office which regulates and enforces data protection law in the UK. Details of how to do this can be found at&nbsp;</span><a href=\"https://www.ico.org.uk/\" style=\"padding: 0px; margin: 0px; color: rgb(14, 40, 42); text-decoration-line: none; border: 0px; outline: none; --darkreader-inline-color:#fffdf6; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-outline: initial;\" data-darkreader-inline-color=\"\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-outline=\"\"><span style=\"font-family: Scandia;\">www.ico.org.uk</span></a></p><ol times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 3px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none decimal; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">COOKIES AND LINKS TO OTHER SITES</span></li></ol><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Cookies</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We use cookies on our website. Cookies files are downloaded to a device when certain websites are accessed by users, allowing the website to identify that user on subsequent visits.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">The only cookies in use on our site are for Google Analytics. Google Analytics are tools employed by organisations to help them understand how visitors engage with their website, so improvements can be made. Google Analytics collects information anonymously – and reports overall trends, without disclosing information on individual visitors. By using our site you are consenting to saving and sending us this data. You can opt out of Google Analytics – which will not affect how you visit our site. Further information on this can be found here:&nbsp;</span><a href=\"https://tools.google.com/dlpage/gaoptout\" style=\"padding: 0px; margin: 0px; color: rgb(14, 40, 42); text-decoration-line: none; border: 0px; outline: none; --darkreader-inline-color:#fffdf6; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-outline: initial;\" data-darkreader-inline-color=\"\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-outline=\"\"><span style=\"font-family: Scandia;\">https://tools.google.com/dlpage/gaoptout</span></a></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Our website uses local storage strictly for system administration to provide you with the best possible experience – used in order to create reports relating to web traffic and user preferences. This includes: your IP address; details of which web browser or operating system was used; and information on how you use the site.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Links to other sites</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Our website contains hyperlinks to many other websites. We are not responsible for the content or functionality of any of those external websites.</span></p><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">If an external website requests personal information from you (e.g. in connection with an order for goods or services), the information you provide will not be covered by the Demos’ Privacy Policy. We suggest you read the privacy policy of any website before providing any personal information.</span></p><ol times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 3px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none decimal; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">CHANGES TO THIS PRIVACY POLICY</span></li></ol><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">We’ll amend this Privacy Policy from time to time to ensure it remains up-to-date and accurately reflects how and why we use your personal data. The current version of our Privacy Policy will always be posted on our website.</span></p></h1><h4 style=\"padding: 0px; margin: 20px 0px; font-weight: normal; color: rgb(58, 72, 81); font-size: 20px; border: 0px; font-family: AR12; white-space: normal; --darkreader-inline-color:#e2dad1; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-color=\"\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Note on compliance with the General Data Protection Regulation as pertaining to use of social media data within Demos projects</span></h4><h1 style=\"padding: 0px; margin: 20px 0px; font-weight: normal; color: rgb(58, 72, 81); font-size: 36px; border: 0px; font-family: AR12; white-space: normal; --darkreader-inline-color:#e2dad1; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-color=\"\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">The Centre for the Analysis of Social Media (CASM) often conducts research which involves the collection and analysis of publicly available data from social media platforms.&nbsp; Much of this data, including usernames, is considered personal data under the General Data Protection Regulation (GDPR). In order to ensure this data is processed lawfully and transparently, the following procedures are followed by CASM projects undertaken by Demos:</span></p><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">All data collected from social media platforms is accessed through the official application programming interface (API) of that platform, and stored and used in compliance with that API’s terms of service.</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Data is only collected from platforms for which users have provided clear consent, as defined in Article 4(11) of the GDPR, to provide that platform with published data</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">CASM often applies techniques in artificial intelligence to social media data, in order to conduct research on this data. As we have throughout our history as a research centre, we ensure that the reasons for applying these techniques, the methodology used to analyse data, and the conclusions drawn from our analysis are presented clearly and fully in each report. This includes publishing detailed accuracy scores for any machine learning algorithms applied as part of the research.</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">This data is securely stored on a monitored server, accessible only to CASM staff, and encrypted in transit. In the event that a data breach is discovered, CASM will act swiftly to ensure that damage from this breach is minimised, including informing relevant supervisory authorities and acting to identify and resolve any security issues allowing the breach.</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Demos will maintain a publicly accessible page on its website for each project, explaining the sources and character of data collected for that project, the purposes for which this data will be used, and including contact details for a designated member of staff responsible for responding to public queries about this data.</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Data collected from social media sites is not stored for longer than is necessary to complete each project</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">In order to respect the rights of data controllers to maintain control of their personal data, CASM will remove from any dataset personal data pertaining to an individual who requests such deletion. This includes taking reasonable measures to ensure that content deleted from social media platforms is also removed from datasets used by CASM.</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">CASM does not publish any personal data collected during its research, nor is personal data shared with third parties external to CASM or transferred out of the UK, without the explicit consent of the data subject. Any data published or shared with a third party is aggregated, anonymised or altered to prevent identification a natural person.</span></li></ul><ul times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px 20px 20px; border: 0px; font-size: 18px; list-style: none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><li style=\"padding: 0px; margin: 5px 0px 5px 20px; border: 0px; list-style: outside none; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">Where quotes from social media users are published in reports, these quotes are bowdlerised – altered in a way which preserves meaning but prevents retroactive identification of the original post through e.g an online search. An occasional exception to this policy is observed when the user is publically known to the extent that they would not reasonably expect their social media posts to be private. It should be noted here that the GDPR only applies to natural persons, and not companies or organisations.</span></li></ul><p times=\"\" new=\"\" roman\",=\"\" times,=\"\" serif;\"=\"\" style=\"padding: 0px; margin: 20px 0px; border: 0px; font-size: 18px; overflow-wrap: break-word; color: rgb(58, 72, 81); --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial; --darkreader-inline-color:#e2dad1;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\" data-darkreader-inline-color=\"\"><span style=\"padding: 0px; margin: 0px; border: 0px; font-family: Scandia; --darkreader-inline-border-top: initial; --darkreader-inline-border-right: initial; --darkreader-inline-border-bottom: initial; --darkreader-inline-border-left: initial;\" data-darkreader-inline-border-top=\"\" data-darkreader-inline-border-right=\"\" data-darkreader-inline-border-bottom=\"\" data-darkreader-inline-border-left=\"\">This Privacy Policy was last updated on 05.07.2020&nbsp;</span></p></h1></pre>', '<p><span style=\"background-color: var(--bg-white); text-align: var(--bs-body-text-align); font-size: 15px; font-family: Scandia;\">Welcome to the Terms of Use for the application. By using the&nbsp;</span><span style=\"background-color: var(--bg-white); text-align: var(--bs-body-text-align); font-size: 15px; font-family: Scandia;\">application, you agree to be bound by these terms and conditions. Please read them carefully before using the application.</span><br></p><p><span style=\"font-size: 15px; font-family: Scandia;\">License Grant:</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: Scandia;\">The</span><span style=\"font-family: Scandia;\">&nbsp;</span></span><span style=\"font-size: 15px; font-family: Scandia;\">application grants you a limited, non-exclusive, non-transferable, revocable license to use the application for your personal or commercial purposes.</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-size: 15px; font-family: Scandia;\">User Conduct:</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: Scandia;\">You agree to use the</span><span style=\"font-family: Scandia;\">&nbsp;</span></span><span style=\"font-size: 15px; font-family: Scandia;\">application for lawful purposes only and not to engage in any conduct that may impair or disrupt the functioning of the application. You agree not to use the application to upload or distribute any content that is illegal, harmful, threatening, abusive, harassing, defamatory, obscene, vulgar, or offensive.</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-size: 15px; font-family: Scandia;\">User Accounts:</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: Scandia;\">You may need to create an account to use certain features of the</span><span style=\"font-family: Scandia;\">&nbsp;</span></span><span style=\"font-size: 15px; font-family: Scandia;\">application. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-size: 15px; font-family: Scandia;\">Intellectual Property:</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: Scandia;\">The</span><span style=\"font-family: Scandia;\">&nbsp;</span></span><span style=\"font-size: 15px; font-family: Scandia;\">application and all of its content, including but not limited to text, graphics, logos, images, and software, are the property of the application owner and are protected by copyright and other intellectual property laws. You may not use or reproduce any of the content without the prior written consent of the application owner.</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-size: 15px; font-family: Scandia;\">Disclaimers:</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: Scandia;\">The</span><span style=\"font-family: Scandia;\">&nbsp;</span></span><span style=\"font-size: 15px; font-family: Scandia;\">application is provided on an \"as is\" and \"as available\" basis. The application owner makes no warranties, express or implied, regarding the application\'s reliability, accuracy, or availability.</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-size: 15px; font-family: Scandia;\">Limitation of Liability:</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: Scandia;\">In no event shall the application owner be liable for any damages arising out of the use or inability to use the</span><span style=\"font-family: Scandia;\">&nbsp;</span></span><span style=\"font-size: 15px; font-family: Scandia;\">application, including but not limited to direct, indirect, incidental, special, or consequential damages.</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-size: 15px; font-family: Scandia;\">Indemnification:</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: Scandia;\">You agree to indemnify and hold the application owner harmless from any claims, damages, losses, or expenses arising out of your use of the</span><span style=\"font-family: Scandia;\">&nbsp;</span></span><span style=\"font-size: 15px; font-family: Scandia;\">application, your violation of these terms and conditions, or your violation of any rights of another person or entity.</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-size: 15px; font-family: Scandia;\">Termination:</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: Scandia;\">The application owner may terminate your access to the</span><span style=\"font-family: Scandia;\">&nbsp;</span></span><span style=\"font-size: 15px; font-family: Scandia;\">application at any time and for any reason without notice.</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-size: 15px; font-family: Scandia;\">Governing Law:</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-size: 15px; font-family: Scandia;\">These terms and conditions shall be governed by and construed in accordance with the laws of the jurisdiction where the application owner is located.</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-size: 15px; font-family: Scandia;\">Changes to Terms and Conditions:</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: Scandia;\">The application owner reserves the right to modify these terms and conditions at any time without notice. Your continued use of the</span><span style=\"font-family: Scandia;\">&nbsp;</span></span><span style=\"font-size: 15px; font-family: Scandia;\">application following any such modifications constitutes your agreement to be bound by the revised terms and conditions.</span><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><br style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: lato, &quot;helvetica neue&quot;, Helvetica, Arial, sans-serif; font-size: 15px;\"><span style=\"font-family: Scandia;\">By using the</span><span style=\"font-family: Scandia;\">&nbsp;</span></span><span style=\"font-size: 15px; font-family: Scandia;\">application, you acknowledge that you have read, understood, and agree to be bound by these terms and conditions.</span><br></p>', '2023-03-22 10:37:41', '2025-02-16 23:23:04');

-- --------------------------------------------------------

--
-- Table structure for table `username_restrictions`
--

CREATE TABLE `username_restrictions` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `identity` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bio` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `interest_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `profile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `background_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_push_notifications` int DEFAULT '1' COMMENT '0 = not push notification.. , 1 = Push notification...\r\n',
  `is_invited_to_room` int DEFAULT '1' COMMENT '0 = Not invited to room pubilcally , 1 = Able to invite in room publically',
  `is_verified` int NOT NULL DEFAULT '0' COMMENT '0 = notVerified, 1 = verificationInPending, 2 = verified, 3 = verifiedBySubscription\r\n\r\n',
  `is_block` int DEFAULT '0' COMMENT '0 = Unblock, 1 = Block',
  `block_user_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `saved_music_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `saved_reel_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `following` int DEFAULT NULL,
  `followers` int DEFAULT NULL,
  `is_moderator` int NOT NULL DEFAULT '0',
  `login_type` int NOT NULL COMMENT '0 = Google login, 1 = Apple Login, 2 = email login\r\n',
  `device_type` int NOT NULL COMMENT '0 = Android / 1 iOS',
  `device_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin_notifications`
--
ALTER TABLE `admin_notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `document_types`
--
ALTER TABLE `document_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `faqs`
--
ALTER TABLE `faqs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `faqs_types`
--
ALTER TABLE `faqs_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `following_lists`
--
ALTER TABLE `following_lists`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `interests`
--
ALTER TABLE `interests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `like_comments`
--
ALTER TABLE `like_comments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `musics`
--
ALTER TABLE `musics`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `music_categories`
--
ALTER TABLE `music_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `post_contents`
--
ALTER TABLE `post_contents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `profile_verifications`
--
ALTER TABLE `profile_verifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reels`
--
ALTER TABLE `reels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `reel_comments`
--
ALTER TABLE `reel_comments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `report_reasons`
--
ALTER TABLE `report_reasons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `room_users`
--
ALTER TABLE `room_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `saved_notifications`
--
ALTER TABLE `saved_notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stories`
--
ALTER TABLE `stories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_pages`
--
ALTER TABLE `tbl_pages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `username_restrictions`
--
ALTER TABLE `username_restrictions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `admin_notifications`
--
ALTER TABLE `admin_notifications`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `document_types`
--
ALTER TABLE `document_types`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faqs`
--
ALTER TABLE `faqs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `faqs_types`
--
ALTER TABLE `faqs_types`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `following_lists`
--
ALTER TABLE `following_lists`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `interests`
--
ALTER TABLE `interests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `likes`
--
ALTER TABLE `likes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `like_comments`
--
ALTER TABLE `like_comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=283;

--
-- AUTO_INCREMENT for table `musics`
--
ALTER TABLE `musics`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `music_categories`
--
ALTER TABLE `music_categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `post_contents`
--
ALTER TABLE `post_contents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `profile_verifications`
--
ALTER TABLE `profile_verifications`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reels`
--
ALTER TABLE `reels`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reel_comments`
--
ALTER TABLE `reel_comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report_reasons`
--
ALTER TABLE `report_reasons`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `room_users`
--
ALTER TABLE `room_users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `saved_notifications`
--
ALTER TABLE `saved_notifications`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `stories`
--
ALTER TABLE `stories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_pages`
--
ALTER TABLE `tbl_pages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `username_restrictions`
--
ALTER TABLE `username_restrictions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
