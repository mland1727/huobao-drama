-- AI短剧生成平台 - MySQL数据库初始化脚本
-- 从 PostgreSQL 迁移
-- 创建时间: 2026-01-31

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ======================================
-- 1. AI服务配置表
-- ======================================

-- AI服务配置表
DROP TABLE IF EXISTS `ai_service_configs`;
CREATE TABLE `ai_service_configs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `service_type` VARCHAR(20) NOT NULL COMMENT 'text, image, video',
  `provider` VARCHAR(50),
  `name` VARCHAR(100) NOT NULL,
  `base_url` VARCHAR(500) NOT NULL,
  `api_key` VARCHAR(500) NOT NULL,
  `model` JSON COMMENT '模型配置',
  `endpoint` VARCHAR(500),
  `query_endpoint` VARCHAR(500),
  `priority` INT NOT NULL DEFAULT 0,
  `is_default` TINYINT(1) NOT NULL DEFAULT 0,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `settings` JSON,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ai_service_configs_service_type` (`service_type`),
  KEY `idx_ai_service_configs_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- AI服务提供商表
DROP TABLE IF EXISTS `ai_service_providers`;
CREATE TABLE `ai_service_providers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `display_name` VARCHAR(100) NOT NULL,
  `service_type` VARCHAR(20) NOT NULL,
  `default_url` VARCHAR(500),
  `description` TEXT,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`),
  KEY `idx_ai_service_providers_service_type` (`service_type`),
  KEY `idx_ai_service_providers_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 初始数据
INSERT INTO `ai_service_providers` (`id`, `name`, `display_name`, `service_type`, `default_url`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'openai', 'OpenAI', 'text', 'https://api.openai.com/v1', 'OpenAI GPT模型', 1, '2026-01-27 21:39:38', '2026-01-27 21:39:38'),
(2, 'openai-dalle', 'OpenAI DALL-E', 'image', 'https://api.openai.com/v1', 'OpenAI 图片生成', 1, '2026-01-27 21:39:38', '2026-01-27 21:39:38'),
(3, 'openai-sora', 'OpenAI Sora', 'video', 'https://api.openai.com/v1', 'OpenAI 视频生成', 1, '2026-01-27 21:39:38', '2026-01-27 21:39:38'),
(4, 'midjourney', 'Midjourney', 'image', '', 'Midjourney 图片生成', 1, '2026-01-27 21:39:38', '2026-01-27 21:39:38'),
(5, 'gemini', 'Google Gemini', 'text', 'https://generativelanguage.googleapis.com', 'Gemini 文本生成', 1, '2026-01-27 21:39:38', '2026-01-27 21:39:38'),
(6, 'runway', 'Runway', 'video', '', 'Runway 视频生成', 1, '2026-01-27 21:39:38', '2026-01-27 21:39:38');

-- ======================================
-- 2. 剧本相关表
-- ======================================

-- 剧本表
DROP TABLE IF EXISTS `dramas`;
CREATE TABLE `dramas` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `description` TEXT,
  `genre` VARCHAR(50),
  `style` VARCHAR(50) NOT NULL DEFAULT 'realistic',
  `total_episodes` INT NOT NULL DEFAULT 1,
  `total_duration` INT NOT NULL DEFAULT 0 COMMENT '总时长(秒)',
  `status` VARCHAR(20) NOT NULL DEFAULT 'draft' COMMENT 'draft, in_progress, completed',
  `thumbnail` VARCHAR(500),
  `tags` JSON,
  `metadata` JSON,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_dramas_status` (`status`),
  KEY `idx_dramas_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 章节表
DROP TABLE IF EXISTS `episodes`;
CREATE TABLE `episodes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `drama_id` BIGINT UNSIGNED NOT NULL,
  `episode_number` INT NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `script_content` LONGTEXT,
  `description` TEXT,
  `duration` INT NOT NULL DEFAULT 0 COMMENT '时长(秒)',
  `status` VARCHAR(20) NOT NULL DEFAULT 'draft',
  `video_url` VARCHAR(500),
  `thumbnail` VARCHAR(500),
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_episodes_drama_id` (`drama_id`),
  KEY `idx_episodes_status` (`status`),
  KEY `idx_episodes_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 角色表
DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `drama_id` BIGINT UNSIGNED NOT NULL,
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
  PRIMARY KEY (`id`),
  KEY `idx_characters_drama_id` (`drama_id`),
  KEY `idx_characters_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 章节角色关系表
DROP TABLE IF EXISTS `episode_characters`;
CREATE TABLE `episode_characters` (
  `episode_id` BIGINT UNSIGNED NOT NULL,
  `character_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`episode_id`, `character_id`),
  KEY `idx_episode_characters_episode_id` (`episode_id`),
  KEY `idx_episode_characters_character_id` (`character_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 道具表
DROP TABLE IF EXISTS `props`;
CREATE TABLE `props` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `drama_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `type` VARCHAR(50),
  `description` TEXT,
  `prompt` TEXT,
  `image_url` VARCHAR(500),
  `reference_images` JSON,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_props_drama_id` (`drama_id`),
  KEY `idx_props_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 场景表
DROP TABLE IF EXISTS `scenes`;
CREATE TABLE `scenes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `drama_id` BIGINT UNSIGNED NOT NULL,
  `episode_id` BIGINT UNSIGNED,
  `location` VARCHAR(200) NOT NULL,
  `time` VARCHAR(100) NOT NULL,
  `prompt` TEXT NOT NULL,
  `storyboard_count` INT NOT NULL DEFAULT 1,
  `image_url` VARCHAR(500),
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'pending, generated, failed',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_scenes_drama_id` (`drama_id`),
  KEY `idx_scenes_episode_id` (`episode_id`),
  KEY `idx_scenes_status` (`status`),
  KEY `idx_scenes_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 分镜表
DROP TABLE IF EXISTS `storyboards`;
CREATE TABLE `storyboards` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `episode_id` BIGINT UNSIGNED NOT NULL,
  `scene_id` BIGINT UNSIGNED,
  `storyboard_number` INT NOT NULL,
  `title` VARCHAR(255),
  `description` TEXT,
  `action` TEXT,
  `dialogue` TEXT,
  `image_prompt` TEXT,
  `video_prompt` TEXT,
  `duration` INT NOT NULL DEFAULT 5 COMMENT '时长(秒)',
  `composed_image` TEXT,
  `video_url` TEXT,
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'pending, processing, completed, failed',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_storyboards_episode_id` (`episode_id`),
  KEY `idx_storyboards_scene_id` (`scene_id`),
  KEY `idx_storyboards_status` (`status`),
  KEY `idx_storyboards_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 分镜角色关系表
DROP TABLE IF EXISTS `storyboard_characters`;
CREATE TABLE `storyboard_characters` (
  `storyboard_id` BIGINT UNSIGNED NOT NULL,
  `character_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`storyboard_id`, `character_id`),
  KEY `idx_storyboard_characters_storyboard_id` (`storyboard_id`),
  KEY `idx_storyboard_characters_character_id` (`character_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 分镜道具关系表
DROP TABLE IF EXISTS `storyboard_props`;
CREATE TABLE `storyboard_props` (
  `storyboard_id` BIGINT UNSIGNED NOT NULL,
  `prop_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`storyboard_id`, `prop_id`),
  KEY `idx_storyboard_props_storyboard_id` (`storyboard_id`),
  KEY `idx_storyboard_props_prop_id` (`prop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================
-- 3. AI生成相关表
-- ======================================

-- 图片生成记录表
DROP TABLE IF EXISTS `image_generations`;
CREATE TABLE `image_generations` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `storyboard_id` BIGINT UNSIGNED,
  `drama_id` BIGINT UNSIGNED NOT NULL,
  `provider` VARCHAR(50) NOT NULL COMMENT 'openai, midjourney, stable_diffusion',
  `prompt` TEXT NOT NULL,
  `negative_prompt` TEXT,
  `model` VARCHAR(100),
  `image_url` VARCHAR(500),
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'pending, processing, completed, failed',
  `task_id` VARCHAR(100),
  `error_msg` TEXT,
  `reference_images` JSON,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `completed_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_image_generations_storyboard_id` (`storyboard_id`),
  KEY `idx_image_generations_drama_id` (`drama_id`),
  KEY `idx_image_generations_status` (`status`),
  KEY `idx_image_generations_task_id` (`task_id`),
  KEY `idx_image_generations_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 视频生成记录表
DROP TABLE IF EXISTS `video_generations`;
CREATE TABLE `video_generations` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `storyboard_id` BIGINT UNSIGNED,
  `drama_id` BIGINT UNSIGNED NOT NULL,
  `provider` VARCHAR(50) NOT NULL COMMENT 'runway, pika, doubao, openai',
  `prompt` TEXT NOT NULL,
  `model` VARCHAR(100),
  `duration` INT COMMENT '时长(秒)',
  `video_url` VARCHAR(500),
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'pending, processing, completed, failed',
  `task_id` VARCHAR(100),
  `error_msg` TEXT,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `completed_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_video_generations_storyboard_id` (`storyboard_id`),
  KEY `idx_video_generations_drama_id` (`drama_id`),
  KEY `idx_video_generations_provider` (`provider`),
  KEY `idx_video_generations_status` (`status`),
  KEY `idx_video_generations_task_id` (`task_id`),
  KEY `idx_video_generations_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 视频合成记录表
DROP TABLE IF EXISTS `video_merges`;
CREATE TABLE `video_merges` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `episode_id` BIGINT UNSIGNED NOT NULL,
  `drama_id` BIGINT UNSIGNED NOT NULL,
  `title` VARCHAR(200),
  `provider` VARCHAR(50) NOT NULL,
  `model` VARCHAR(100),
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'pending, processing, completed, failed',
  `scenes` JSON NOT NULL COMMENT '场景片段列表',
  `merged_url` VARCHAR(500),
  `duration` INT COMMENT '总时长(秒)',
  `task_id` VARCHAR(100),
  `error_msg` TEXT,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_video_merges_episode_id` (`episode_id`),
  KEY `idx_video_merges_drama_id` (`drama_id`),
  KEY `idx_video_merges_status` (`status`),
  KEY `idx_video_merges_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 帧提示词表
DROP TABLE IF EXISTS `frame_prompts`;
CREATE TABLE `frame_prompts` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `drama_id` BIGINT UNSIGNED NOT NULL,
  `episode_id` BIGINT UNSIGNED,
  `storyboard_id` BIGINT UNSIGNED,
  `frame_type` VARCHAR(20) NOT NULL COMMENT 'start, middle, end',
  `frame_number` INT NOT NULL,
  `prompt` TEXT NOT NULL,
  `negative_prompt` TEXT,
  `reference_image` VARCHAR(500),
  `generated_image` VARCHAR(500),
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'pending, processing, completed, failed',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_frame_prompts_drama_id` (`drama_id`),
  KEY `idx_frame_prompts_episode_id` (`episode_id`),
  KEY `idx_frame_prompts_storyboard_id` (`storyboard_id`),
  KEY `idx_frame_prompts_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================
-- 4. 异步任务表
-- ======================================

DROP TABLE IF EXISTS `async_tasks`;
CREATE TABLE `async_tasks` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `task_type` VARCHAR(50) NOT NULL COMMENT 'script_generation, image_generation, video_generation, etc.',
  `drama_id` BIGINT UNSIGNED,
  `episode_id` BIGINT UNSIGNED,
  `storyboard_id` BIGINT UNSIGNED,
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'pending, processing, completed, failed',
  `progress` INT NOT NULL DEFAULT 0 COMMENT '进度百分比 0-100',
  `result` JSON,
  `error_msg` TEXT,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `completed_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_async_tasks_task_type` (`task_type`),
  KEY `idx_async_tasks_drama_id` (`drama_id`),
  KEY `idx_async_tasks_status` (`status`),
  KEY `idx_async_tasks_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================
-- 5. 角色库表
-- ======================================

DROP TABLE IF EXISTS `character_libraries`;
CREATE TABLE `character_libraries` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `category` VARCHAR(50),
  `image_url` VARCHAR(500) NOT NULL,
  `description` TEXT,
  `tags` VARCHAR(500),
  `source_type` VARCHAR(20) NOT NULL DEFAULT 'generated' COMMENT 'generated, uploaded',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_character_libraries_category` (`category`),
  KEY `idx_character_libraries_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================
-- 6. 时间线相关表
-- ======================================

-- 时间线表
DROP TABLE IF EXISTS `timelines`;
CREATE TABLE `timelines` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `drama_id` BIGINT UNSIGNED NOT NULL,
  `episode_id` BIGINT UNSIGNED,
  `name` VARCHAR(200) NOT NULL,
  `description` TEXT,
  `duration` INT NOT NULL DEFAULT 0 COMMENT '总时长(秒)',
  `fps` INT NOT NULL DEFAULT 30,
  `resolution` VARCHAR(20),
  `status` VARCHAR(20) NOT NULL DEFAULT 'draft' COMMENT 'draft, editing, completed, exporting',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timelines_drama_id` (`drama_id`),
  KEY `idx_timelines_episode_id` (`episode_id`),
  KEY `idx_timelines_status` (`status`),
  KEY `idx_timelines_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 时间线轨道表
DROP TABLE IF EXISTS `timeline_tracks`;
CREATE TABLE `timeline_tracks` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `timeline_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `type` VARCHAR(20) NOT NULL COMMENT 'video, audio, text',
  `track_order` INT NOT NULL DEFAULT 0,
  `is_locked` TINYINT(1) NOT NULL DEFAULT 0,
  `is_muted` TINYINT(1) NOT NULL DEFAULT 0,
  `volume` INT DEFAULT 100,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timeline_tracks_timeline_id` (`timeline_id`),
  KEY `idx_timeline_tracks_type` (`type`),
  KEY `idx_timeline_tracks_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 时间线片段表
DROP TABLE IF EXISTS `timeline_clips`;
CREATE TABLE `timeline_clips` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `track_id` BIGINT UNSIGNED NOT NULL,
  `asset_id` BIGINT UNSIGNED,
  `storyboard_id` BIGINT UNSIGNED,
  `name` VARCHAR(200),
  `start_time` BIGINT NOT NULL COMMENT '开始时间(毫秒)',
  `end_time` BIGINT NOT NULL COMMENT '结束时间(毫秒)',
  `duration` BIGINT NOT NULL COMMENT '时长(毫秒)',
  `trim_start` BIGINT COMMENT '裁剪开始(毫秒)',
  `trim_end` BIGINT COMMENT '裁剪结束(毫秒)',
  `speed` DECIMAL(4,2) DEFAULT 1.00,
  `volume` INT,
  `is_muted` TINYINT(1) NOT NULL DEFAULT 0,
  `fade_in` BIGINT COMMENT '淡入时长(毫秒)',
  `fade_out` BIGINT COMMENT '淡出时长(毫秒)',
  `transition_in_id` BIGINT UNSIGNED,
  `transition_out_id` BIGINT UNSIGNED,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timeline_clips_track_id` (`track_id`),
  KEY `idx_timeline_clips_asset_id` (`asset_id`),
  KEY `idx_timeline_clips_storyboard_id` (`storyboard_id`),
  KEY `idx_timeline_clips_transition_in` (`transition_in_id`),
  KEY `idx_timeline_clips_transition_out` (`transition_out_id`),
  KEY `idx_timeline_clips_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 片段转场表
DROP TABLE IF EXISTS `clip_transitions`;
CREATE TABLE `clip_transitions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(50) NOT NULL COMMENT 'fade, crossfade, slide, wipe, zoom, dissolve',
  `duration` INT NOT NULL DEFAULT 500 COMMENT '转场时长(毫秒)',
  `easing` VARCHAR(50),
  `config` JSON,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_clip_transitions_type` (`type`),
  KEY `idx_clip_transitions_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 片段效果表
DROP TABLE IF EXISTS `clip_effects`;
CREATE TABLE `clip_effects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `clip_id` BIGINT UNSIGNED NOT NULL,
  `type` VARCHAR(50) NOT NULL COMMENT 'filter, color, blur, brightness, contrast, saturation',
  `name` VARCHAR(100),
  `is_enabled` TINYINT(1) NOT NULL DEFAULT 1,
  `effect_order` INT NOT NULL DEFAULT 0,
  `config` JSON,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_clip_effects_clip_id` (`clip_id`),
  KEY `idx_clip_effects_type` (`type`),
  KEY `idx_clip_effects_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================
-- 7. 资源管理相关表
-- ======================================

-- 资源表
DROP TABLE IF EXISTS `assets`;
CREATE TABLE `assets` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `drama_id` BIGINT UNSIGNED,
  `name` VARCHAR(200) NOT NULL,
  `description` TEXT,
  `type` VARCHAR(20) NOT NULL COMMENT 'image, video, audio',
  `category` VARCHAR(50),
  `url` VARCHAR(500) NOT NULL,
  `thumbnail_url` VARCHAR(500),
  `local_path` VARCHAR(500),
  `file_size` BIGINT,
  `mime_type` VARCHAR(100),
  `width` INT,
  `height` INT,
  `duration` INT COMMENT '时长(秒)',
  `format` VARCHAR(20),
  `image_gen_id` BIGINT UNSIGNED,
  `video_gen_id` BIGINT UNSIGNED,
  `is_favorite` TINYINT(1) NOT NULL DEFAULT 0,
  `view_count` INT NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_assets_drama_id` (`drama_id`),
  KEY `idx_assets_type` (`type`),
  KEY `idx_assets_category` (`category`),
  KEY `idx_assets_image_gen_id` (`image_gen_id`),
  KEY `idx_assets_video_gen_id` (`video_gen_id`),
  KEY `idx_assets_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 资源标签表
DROP TABLE IF EXISTS `asset_tags`;
CREATE TABLE `asset_tags` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `color` VARCHAR(20),
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_asset_tags_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 资源集合表
DROP TABLE IF EXISTS `asset_collections`;
CREATE TABLE `asset_collections` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `drama_id` BIGINT UNSIGNED,
  `name` VARCHAR(200) NOT NULL,
  `description` TEXT,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_asset_collections_drama_id` (`drama_id`),
  KEY `idx_asset_collections_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 资源标签关系表(多对多)
DROP TABLE IF EXISTS `asset_tag_relations`;
CREATE TABLE `asset_tag_relations` (
  `asset_id` BIGINT UNSIGNED NOT NULL,
  `asset_tag_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`asset_id`, `asset_tag_id`),
  KEY `idx_asset_tag_relations_asset_id` (`asset_id`),
  KEY `idx_asset_tag_relations_tag_id` (`asset_tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 资源集合关系表(多对多)
DROP TABLE IF EXISTS `asset_collection_relations`;
CREATE TABLE `asset_collection_relations` (
  `asset_id` BIGINT UNSIGNED NOT NULL,
  `asset_collection_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`asset_id`, `asset_collection_id`),
  KEY `idx_asset_collection_relations_asset_id` (`asset_id`),
  KEY `idx_asset_collection_relations_collection_id` (`asset_collection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;