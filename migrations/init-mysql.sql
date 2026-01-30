-- =====================================================
-- AI短剧生成平台 - MySQL 初始化脚本
-- 时间字段统一使用 TIMESTAMP
-- 无外键设计,适合 AI 异步生成流水线
-- =====================================================

SET time_zone = '+00:00';
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- =====================================================
-- 1. 剧本相关
-- =====================================================

DROP TABLE IF EXISTS `dramas`;
CREATE TABLE `dramas` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(200) NOT NULL,
    `description` TEXT,
    `genre` VARCHAR(50),
    `style` VARCHAR(50) NOT NULL DEFAULT 'realistic',
    `total_episodes` INT NOT NULL DEFAULT 1,
    `total_duration` INT NOT NULL DEFAULT 0,
    `status` VARCHAR(20) NOT NULL DEFAULT 'draft',
    `thumbnail` VARCHAR(500),
    `tags` JSON,
    `metadata` JSON,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL,
    INDEX `idx_dramas_status` (`status`),
    INDEX `idx_dramas_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 章节
-- =====================================================

DROP TABLE IF EXISTS `episodes`;
CREATE TABLE `episodes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `drama_id` INT NOT NULL,
    `episode_number` INT NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `script_content` TEXT,
    `description` TEXT,
    `duration` INT NOT NULL DEFAULT 0,
    `status` VARCHAR(20) NOT NULL DEFAULT 'draft',
    `video_url` VARCHAR(500),
    `thumbnail` VARCHAR(500),
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL,
    INDEX `idx_episodes_drama_id` (`drama_id`),
    INDEX `idx_episodes_status` (`status`),
    INDEX `idx_episodes_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 角色
-- =====================================================

DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `drama_id` INT NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `role` VARCHAR(50),
    `description` TEXT,
    `appearance` TEXT,
    `personality` TEXT,
    `voice_style` VARCHAR(200),
    `image_url` VARCHAR(500),
    `reference_images` JSON,
    `seed_value` VARCHAR(100),
    `sort_order` INT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL,
    INDEX `idx_characters_drama_id` (`drama_id`),
    INDEX `idx_characters_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 章节-角色
-- =====================================================

DROP TABLE IF EXISTS `episode_characters`;
CREATE TABLE `episode_characters` (
    `episode_id` INT NOT NULL,
    `character_id` INT NOT NULL,
    PRIMARY KEY (`episode_id`, `character_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 场景
-- =====================================================

DROP TABLE IF EXISTS `scenes`;
CREATE TABLE `scenes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `drama_id` INT NOT NULL,
    `episode_id` INT,
    `location` VARCHAR(200) NOT NULL,
    `time` VARCHAR(100) NOT NULL,
    `prompt` TEXT NOT NULL,
    `storyboard_count` INT NOT NULL DEFAULT 1,
    `image_url` VARCHAR(500),
    `status` VARCHAR(20) NOT NULL DEFAULT 'pending',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL,
    INDEX `idx_scenes_drama_id` (`drama_id`),
    INDEX `idx_scenes_episode_id` (`episode_id`),
    INDEX `idx_scenes_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 分镜
-- =====================================================

DROP TABLE IF EXISTS `storyboards`;
CREATE TABLE `storyboards` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `episode_id` INT NOT NULL,
    `scene_id` INT,
    `storyboard_number` INT NOT NULL,
    `title` VARCHAR(255),
    `description` TEXT,
    `action` TEXT,
    `dialogue` TEXT,
    `image_prompt` TEXT,
    `video_prompt` TEXT,
    `duration` INT NOT NULL DEFAULT 5,
    `composed_image` TEXT,
    `video_url` TEXT,
    `status` VARCHAR(20) NOT NULL DEFAULT 'pending',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL,
    INDEX `idx_storyboards_episode_id` (`episode_id`),
    INDEX `idx_storyboards_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 2. AI 生成
-- =====================================================

DROP TABLE IF EXISTS `image_generations`;
CREATE TABLE `image_generations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `storyboard_id` INT,
    `drama_id` INT NOT NULL,
    `provider` VARCHAR(50) NOT NULL,
    `prompt` TEXT NOT NULL,
    `negative_prompt` TEXT,
    `model` VARCHAR(100),
    `image_url` VARCHAR(500),
    `status` VARCHAR(20) NOT NULL DEFAULT 'pending',
    `task_id` VARCHAR(100),
    `error_msg` TEXT,
    `reference_images` JSON,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `completed_at` TIMESTAMP NULL DEFAULT NULL,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL,
    INDEX `idx_image_generations_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `video_generations`;
CREATE TABLE `video_generations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `storyboard_id` INT,
    `drama_id` INT NOT NULL,
    `provider` VARCHAR(50) NOT NULL,
    `prompt` TEXT NOT NULL,
    `model` VARCHAR(100),
    `duration` INT,
    `video_url` VARCHAR(500),
    `status` VARCHAR(20) NOT NULL DEFAULT 'pending',
    `task_id` VARCHAR(100),
    `error_msg` TEXT,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `completed_at` TIMESTAMP NULL DEFAULT NULL,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 3. AI 服务配置
-- =====================================================

DROP TABLE IF EXISTS `ai_service_configs`;
CREATE TABLE `ai_service_configs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `service_type` VARCHAR(20) NOT NULL,
    `provider` VARCHAR(50),
    `name` VARCHAR(100) NOT NULL,
    `base_url` VARCHAR(500) NOT NULL,
    `api_key` VARCHAR(500) NOT NULL,
    `model` JSON,
    `endpoint` VARCHAR(500),
    `query_endpoint` VARCHAR(500),
    `priority` INT NOT NULL DEFAULT 0,
    `is_default` BOOLEAN NOT NULL DEFAULT FALSE,
    `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
    `settings` JSON,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `ai_service_providers`;
CREATE TABLE `ai_service_providers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `display_name` VARCHAR(100) NOT NULL,
    `service_type` VARCHAR(20) NOT NULL,
    `default_url` VARCHAR(500),
    `description` TEXT,
    `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 初始数据
-- =====================================================

INSERT INTO `ai_service_providers`
(`name`, `display_name`, `service_type`, `default_url`, `description`)
VALUES
('openai', 'OpenAI', 'text', 'https://api.openai.com/v1', 'OpenAI GPT模型'),
('openai-dalle', 'OpenAI DALL-E', 'image', 'https://api.openai.com/v1', 'OpenAI 图片生成'),
('openai-sora', 'OpenAI Sora', 'video', 'https://api.openai.com/v1', 'OpenAI 视频生成'),
('midjourney', 'Midjourney', 'image', '', 'Midjourney 图片生成'),
('gemini', 'Google Gemini', 'text', 'https://generativelanguage.googleapis.com', 'Gemini 文本生成'),
('runway', 'Runway', 'video', '', 'Runway 视频生成')
ON DUPLICATE KEY UPDATE `name`=`name`;