/*
 Navicat Premium Dump SQL

 Source Server         : 火爆Drama
 Source Server Type    : PostgreSQL
 Source Server Version : 180000 (180000)
 Source Host           : 180.184.144.93:5432
 Source Catalog        : huobao
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 180000 (180000)
 File Encoding         : 65001

 Date: 31/01/2026 10:34:37
*/


-- ----------------------------
-- Sequence structure for ai_service_configs_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."ai_service_configs_id_seq";
CREATE SEQUENCE "public"."ai_service_configs_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for ai_service_providers_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."ai_service_providers_id_seq";
CREATE SEQUENCE "public"."ai_service_providers_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for asset_collections_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."asset_collections_id_seq";
CREATE SEQUENCE "public"."asset_collections_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for asset_tags_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."asset_tags_id_seq";
CREATE SEQUENCE "public"."asset_tags_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for assets_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."assets_id_seq";
CREATE SEQUENCE "public"."assets_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for async_tasks_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."async_tasks_id_seq";
CREATE SEQUENCE "public"."async_tasks_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for character_libraries_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."character_libraries_id_seq";
CREATE SEQUENCE "public"."character_libraries_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for characters_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."characters_id_seq";
CREATE SEQUENCE "public"."characters_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for clip_effects_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."clip_effects_id_seq";
CREATE SEQUENCE "public"."clip_effects_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for clip_transitions_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."clip_transitions_id_seq";
CREATE SEQUENCE "public"."clip_transitions_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for dramas_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."dramas_id_seq";
CREATE SEQUENCE "public"."dramas_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for episodes_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."episodes_id_seq";
CREATE SEQUENCE "public"."episodes_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for frame_prompts_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."frame_prompts_id_seq";
CREATE SEQUENCE "public"."frame_prompts_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for image_generations_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."image_generations_id_seq";
CREATE SEQUENCE "public"."image_generations_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for props_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."props_id_seq";
CREATE SEQUENCE "public"."props_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for scenes_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."scenes_id_seq";
CREATE SEQUENCE "public"."scenes_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for storyboards_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."storyboards_id_seq";
CREATE SEQUENCE "public"."storyboards_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for timeline_clips_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."timeline_clips_id_seq";
CREATE SEQUENCE "public"."timeline_clips_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for timeline_tracks_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."timeline_tracks_id_seq";
CREATE SEQUENCE "public"."timeline_tracks_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for timelines_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."timelines_id_seq";
CREATE SEQUENCE "public"."timelines_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for video_generations_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."video_generations_id_seq";
CREATE SEQUENCE "public"."video_generations_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for video_merges_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."video_merges_id_seq";
CREATE SEQUENCE "public"."video_merges_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for ai_service_configs
-- ----------------------------
DROP TABLE IF EXISTS "public"."ai_service_configs";
CREATE TABLE "public"."ai_service_configs" (
  "id" int4 NOT NULL DEFAULT nextval('ai_service_configs_id_seq'::regclass),
  "service_type" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "provider" varchar(50) COLLATE "pg_catalog"."default",
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "base_url" varchar(500) COLLATE "pg_catalog"."default" NOT NULL,
  "api_key" varchar(500) COLLATE "pg_catalog"."default" NOT NULL,
  "model" jsonb,
  "endpoint" varchar(500) COLLATE "pg_catalog"."default",
  "query_endpoint" varchar(500) COLLATE "pg_catalog"."default",
  "priority" int4 NOT NULL DEFAULT 0,
  "is_default" bool NOT NULL DEFAULT false,
  "is_active" bool NOT NULL DEFAULT true,
  "settings" jsonb,
  "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamptz(6)
)
;

-- ----------------------------
-- Table structure for ai_service_providers
-- ----------------------------
DROP TABLE IF EXISTS "public"."ai_service_providers";
CREATE TABLE "public"."ai_service_providers" (
  "id" int4 NOT NULL DEFAULT nextval('ai_service_providers_id_seq'::regclass),
  "name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "display_name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "service_type" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "default_url" varchar(500) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "is_active" bool NOT NULL DEFAULT true,
  "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of ai_service_providers
-- ----------------------------
INSERT INTO "public"."ai_service_providers" VALUES (1, 'openai', 'OpenAI', 'text', 'https://api.openai.com/v1', 'OpenAI GPT模型', 't', '2026-01-27 21:39:38.255971+08', '2026-01-27 21:39:38.255971+08', NULL);
INSERT INTO "public"."ai_service_providers" VALUES (2, 'openai-dalle', 'OpenAI DALL-E', 'image', 'https://api.openai.com/v1', 'OpenAI 图片生成', 't', '2026-01-27 21:39:38.255971+08', '2026-01-27 21:39:38.255971+08', NULL);
INSERT INTO "public"."ai_service_providers" VALUES (3, 'openai-sora', 'OpenAI Sora', 'video', 'https://api.openai.com/v1', 'OpenAI 视频生成', 't', '2026-01-27 21:39:38.255971+08', '2026-01-27 21:39:38.255971+08', NULL);
INSERT INTO "public"."ai_service_providers" VALUES (4, 'midjourney', 'Midjourney', 'image', '', 'Midjourney 图片生成', 't', '2026-01-27 21:39:38.255971+08', '2026-01-27 21:39:38.255971+08', NULL);
INSERT INTO "public"."ai_service_providers" VALUES (5, 'gemini', 'Google Gemini', 'text', 'https://generativelanguage.googleapis.com', 'Gemini 文本生成', 't', '2026-01-27 21:39:38.255971+08', '2026-01-27 21:39:38.255971+08', NULL);
INSERT INTO "public"."ai_service_providers" VALUES (6, 'runway', 'Runway', 'video', '', 'Runway 视频生成', 't', '2026-01-27 21:39:38.255971+08', '2026-01-27 21:39:38.255971+08', NULL);

-- ----------------------------
-- Table structure for asset_collection_relations
-- ----------------------------
DROP TABLE IF EXISTS "public"."asset_collection_relations";
CREATE TABLE "public"."asset_collection_relations" (
  "asset_id" int4 NOT NULL,
  "asset_collection_id" int4 NOT NULL
)
;

-- ----------------------------
-- Records of asset_collection_relations
-- ----------------------------

-- ----------------------------
-- Table structure for asset_collections
-- ----------------------------
DROP TABLE IF EXISTS "public"."asset_collections";
CREATE TABLE "public"."asset_collections" (
  "id" int4 NOT NULL DEFAULT nextval('asset_collections_id_seq'::regclass),
  "drama_id" int4,
  "name" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of asset_collections
-- ----------------------------

-- ----------------------------
-- Table structure for asset_tag_relations
-- ----------------------------
DROP TABLE IF EXISTS "public"."asset_tag_relations";
CREATE TABLE "public"."asset_tag_relations" (
  "asset_id" int4 NOT NULL,
  "asset_tag_id" int4 NOT NULL
)
;

-- ----------------------------
-- Records of asset_tag_relations
-- ----------------------------

-- ----------------------------
-- Table structure for asset_tags
-- ----------------------------
DROP TABLE IF EXISTS "public"."asset_tags";
CREATE TABLE "public"."asset_tags" (
  "id" int4 NOT NULL DEFAULT nextval('asset_tags_id_seq'::regclass),
  "name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "color" varchar(20) COLLATE "pg_catalog"."default",
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of asset_tags
-- ----------------------------

-- ----------------------------
-- Table structure for assets
-- ----------------------------
DROP TABLE IF EXISTS "public"."assets";
CREATE TABLE "public"."assets" (
  "id" int4 NOT NULL DEFAULT nextval('assets_id_seq'::regclass),
  "drama_id" int4,
  "name" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "type" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "category" varchar(50) COLLATE "pg_catalog"."default",
  "url" varchar(500) COLLATE "pg_catalog"."default" NOT NULL,
  "thumbnail_url" varchar(500) COLLATE "pg_catalog"."default",
  "local_path" varchar(500) COLLATE "pg_catalog"."default",
  "file_size" int8,
  "mime_type" varchar(100) COLLATE "pg_catalog"."default",
  "width" int4,
  "height" int4,
  "duration" int4,
  "format" varchar(20) COLLATE "pg_catalog"."default",
  "image_gen_id" int4,
  "video_gen_id" int4,
  "is_favorite" bool NOT NULL DEFAULT false,
  "view_count" int4 NOT NULL DEFAULT 0,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of assets
-- ----------------------------

-- ----------------------------
-- Table structure for async_tasks
-- ----------------------------
DROP TABLE IF EXISTS "public"."async_tasks";
CREATE TABLE "public"."async_tasks" (
  "id" int4 NOT NULL DEFAULT nextval('async_tasks_id_seq'::regclass),
  "task_type" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "drama_id" int4,
  "episode_id" int4,
  "storyboard_id" int4,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'pending'::character varying,
  "progress" int4 NOT NULL DEFAULT 0,
  "result" jsonb,
  "error_msg" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "completed_at" timestamp(6),
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of async_tasks
-- ----------------------------

-- ----------------------------
-- Table structure for character_libraries
-- ----------------------------
DROP TABLE IF EXISTS "public"."character_libraries";
CREATE TABLE "public"."character_libraries" (
  "id" int4 NOT NULL DEFAULT nextval('character_libraries_id_seq'::regclass),
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "category" varchar(50) COLLATE "pg_catalog"."default",
  "image_url" varchar(500) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "tags" varchar(500) COLLATE "pg_catalog"."default",
  "source_type" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'generated'::character varying,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of character_libraries
-- ----------------------------

-- ----------------------------
-- Table structure for characters
-- ----------------------------
DROP TABLE IF EXISTS "public"."characters";
CREATE TABLE "public"."characters" (
  "id" int4 NOT NULL DEFAULT nextval('characters_id_seq'::regclass),
  "drama_id" int4 NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "role" varchar(50) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "appearance" text COLLATE "pg_catalog"."default",
  "personality" text COLLATE "pg_catalog"."default",
  "voice_style" varchar(200) COLLATE "pg_catalog"."default",
  "image_url" varchar(500) COLLATE "pg_catalog"."default",
  "reference_images" jsonb,
  "seed_value" varchar(100) COLLATE "pg_catalog"."default",
  "sort_order" int4 NOT NULL DEFAULT 0,
  "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of characters
-- ----------------------------

-- ----------------------------
-- Table structure for clip_effects
-- ----------------------------
DROP TABLE IF EXISTS "public"."clip_effects";
CREATE TABLE "public"."clip_effects" (
  "id" int4 NOT NULL DEFAULT nextval('clip_effects_id_seq'::regclass),
  "clip_id" int4 NOT NULL,
  "type" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default",
  "is_enabled" bool NOT NULL DEFAULT true,
  "effect_order" int4 NOT NULL DEFAULT 0,
  "config" jsonb,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of clip_effects
-- ----------------------------

-- ----------------------------
-- Table structure for clip_transitions
-- ----------------------------
DROP TABLE IF EXISTS "public"."clip_transitions";
CREATE TABLE "public"."clip_transitions" (
  "id" int4 NOT NULL DEFAULT nextval('clip_transitions_id_seq'::regclass),
  "type" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "duration" int4 NOT NULL DEFAULT 500,
  "easing" varchar(50) COLLATE "pg_catalog"."default",
  "config" jsonb,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of clip_transitions
-- ----------------------------

-- ----------------------------
-- Table structure for dramas
-- ----------------------------
DROP TABLE IF EXISTS "public"."dramas";
CREATE TABLE "public"."dramas" (
  "id" int4 NOT NULL DEFAULT nextval('dramas_id_seq'::regclass),
  "title" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "genre" varchar(50) COLLATE "pg_catalog"."default",
  "style" varchar(50) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'realistic'::character varying,
  "total_episodes" int4 NOT NULL DEFAULT 1,
  "total_duration" int4 NOT NULL DEFAULT 0,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'draft'::character varying,
  "thumbnail" varchar(500) COLLATE "pg_catalog"."default",
  "tags" jsonb,
  "metadata" jsonb,
  "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamptz(6)
)
;

-- ----------------------------
-- Table structure for episode_characters
-- ----------------------------
DROP TABLE IF EXISTS "public"."episode_characters";
CREATE TABLE "public"."episode_characters" (
  "episode_id" int4 NOT NULL,
  "character_id" int4 NOT NULL
)
;

-- ----------------------------
-- Records of episode_characters
-- ----------------------------

-- ----------------------------
-- Table structure for episodes
-- ----------------------------
DROP TABLE IF EXISTS "public"."episodes";
CREATE TABLE "public"."episodes" (
  "id" int4 NOT NULL DEFAULT nextval('episodes_id_seq'::regclass),
  "drama_id" int4 NOT NULL,
  "episode_number" int4 NOT NULL,
  "title" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "script_content" text COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "duration" int4 NOT NULL DEFAULT 0,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'draft'::character varying,
  "video_url" varchar(500) COLLATE "pg_catalog"."default",
  "thumbnail" varchar(500) COLLATE "pg_catalog"."default",
  "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamptz(6)
)
;

-- ----------------------------
-- Table structure for frame_prompts
-- ----------------------------
DROP TABLE IF EXISTS "public"."frame_prompts";
CREATE TABLE "public"."frame_prompts" (
  "id" int4 NOT NULL DEFAULT nextval('frame_prompts_id_seq'::regclass),
  "drama_id" int4 NOT NULL,
  "episode_id" int4,
  "storyboard_id" int4,
  "frame_type" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "frame_number" int4 NOT NULL,
  "prompt" text COLLATE "pg_catalog"."default" NOT NULL,
  "negative_prompt" text COLLATE "pg_catalog"."default",
  "reference_image" varchar(500) COLLATE "pg_catalog"."default",
  "generated_image" varchar(500) COLLATE "pg_catalog"."default",
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'pending'::character varying,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of frame_prompts
-- ----------------------------

-- ----------------------------
-- Table structure for image_generations
-- ----------------------------
DROP TABLE IF EXISTS "public"."image_generations";
CREATE TABLE "public"."image_generations" (
  "id" int4 NOT NULL DEFAULT nextval('image_generations_id_seq'::regclass),
  "storyboard_id" int4,
  "drama_id" int4 NOT NULL,
  "provider" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "prompt" text COLLATE "pg_catalog"."default" NOT NULL,
  "negative_prompt" text COLLATE "pg_catalog"."default",
  "model" varchar(100) COLLATE "pg_catalog"."default",
  "image_url" varchar(500) COLLATE "pg_catalog"."default",
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'pending'::character varying,
  "task_id" varchar(100) COLLATE "pg_catalog"."default",
  "error_msg" text COLLATE "pg_catalog"."default",
  "reference_images" jsonb,
  "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "completed_at" timestamptz(6),
  "deleted_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of image_generations
-- ----------------------------

-- ----------------------------
-- Table structure for props
-- ----------------------------
DROP TABLE IF EXISTS "public"."props";
CREATE TABLE "public"."props" (
  "id" int4 NOT NULL DEFAULT nextval('props_id_seq'::regclass),
  "drama_id" int4 NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "type" varchar(50) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "prompt" text COLLATE "pg_catalog"."default",
  "image_url" varchar(500) COLLATE "pg_catalog"."default",
  "reference_images" jsonb,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of props
-- ----------------------------

-- ----------------------------
-- Table structure for scenes
-- ----------------------------
DROP TABLE IF EXISTS "public"."scenes";
CREATE TABLE "public"."scenes" (
  "id" int4 NOT NULL DEFAULT nextval('scenes_id_seq'::regclass),
  "drama_id" int4 NOT NULL,
  "episode_id" int4,
  "location" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "time" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "prompt" text COLLATE "pg_catalog"."default" NOT NULL,
  "storyboard_count" int4 NOT NULL DEFAULT 1,
  "image_url" varchar(500) COLLATE "pg_catalog"."default",
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'pending'::character varying,
  "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of scenes
-- ----------------------------

-- ----------------------------
-- Table structure for storyboard_characters
-- ----------------------------
DROP TABLE IF EXISTS "public"."storyboard_characters";
CREATE TABLE "public"."storyboard_characters" (
  "storyboard_id" int4 NOT NULL,
  "character_id" int4 NOT NULL
)
;

-- ----------------------------
-- Records of storyboard_characters
-- ----------------------------

-- ----------------------------
-- Table structure for storyboard_props
-- ----------------------------
DROP TABLE IF EXISTS "public"."storyboard_props";
CREATE TABLE "public"."storyboard_props" (
  "storyboard_id" int4 NOT NULL,
  "prop_id" int4 NOT NULL
)
;

-- ----------------------------
-- Records of storyboard_props
-- ----------------------------

-- ----------------------------
-- Table structure for storyboards
-- ----------------------------
DROP TABLE IF EXISTS "public"."storyboards";
CREATE TABLE "public"."storyboards" (
  "id" int4 NOT NULL DEFAULT nextval('storyboards_id_seq'::regclass),
  "episode_id" int4 NOT NULL,
  "scene_id" int4,
  "storyboard_number" int4 NOT NULL,
  "title" varchar(255) COLLATE "pg_catalog"."default",
  "description" text COLLATE "pg_catalog"."default",
  "action" text COLLATE "pg_catalog"."default",
  "dialogue" text COLLATE "pg_catalog"."default",
  "image_prompt" text COLLATE "pg_catalog"."default",
  "video_prompt" text COLLATE "pg_catalog"."default",
  "duration" int4 NOT NULL DEFAULT 5,
  "composed_image" text COLLATE "pg_catalog"."default",
  "video_url" text COLLATE "pg_catalog"."default",
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'pending'::character varying,
  "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of storyboards
-- ----------------------------

-- ----------------------------
-- Table structure for timeline_clips
-- ----------------------------
DROP TABLE IF EXISTS "public"."timeline_clips";
CREATE TABLE "public"."timeline_clips" (
  "id" int4 NOT NULL DEFAULT nextval('timeline_clips_id_seq'::regclass),
  "track_id" int4 NOT NULL,
  "asset_id" int4,
  "storyboard_id" int4,
  "name" varchar(200) COLLATE "pg_catalog"."default",
  "start_time" int8 NOT NULL,
  "end_time" int8 NOT NULL,
  "duration" int8 NOT NULL,
  "trim_start" int8,
  "trim_end" int8,
  "speed" numeric(4,2) DEFAULT 1.0,
  "volume" int4,
  "is_muted" bool NOT NULL DEFAULT false,
  "fade_in" int8,
  "fade_out" int8,
  "transition_in_id" int4,
  "transition_out_id" int4,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of timeline_clips
-- ----------------------------

-- ----------------------------
-- Table structure for timeline_tracks
-- ----------------------------
DROP TABLE IF EXISTS "public"."timeline_tracks";
CREATE TABLE "public"."timeline_tracks" (
  "id" int4 NOT NULL DEFAULT nextval('timeline_tracks_id_seq'::regclass),
  "timeline_id" int4 NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "type" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "track_order" int4 NOT NULL DEFAULT 0,
  "is_locked" bool NOT NULL DEFAULT false,
  "is_muted" bool NOT NULL DEFAULT false,
  "volume" int4 DEFAULT 100,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of timeline_tracks
-- ----------------------------

-- ----------------------------
-- Table structure for timelines
-- ----------------------------
DROP TABLE IF EXISTS "public"."timelines";
CREATE TABLE "public"."timelines" (
  "id" int4 NOT NULL DEFAULT nextval('timelines_id_seq'::regclass),
  "drama_id" int4 NOT NULL,
  "episode_id" int4,
  "name" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "duration" int4 NOT NULL DEFAULT 0,
  "fps" int4 NOT NULL DEFAULT 30,
  "resolution" varchar(20) COLLATE "pg_catalog"."default",
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'draft'::character varying,
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of timelines
-- ----------------------------

-- ----------------------------
-- Table structure for video_generations
-- ----------------------------
DROP TABLE IF EXISTS "public"."video_generations";
CREATE TABLE "public"."video_generations" (
  "id" int4 NOT NULL DEFAULT nextval('video_generations_id_seq'::regclass),
  "storyboard_id" int4,
  "drama_id" int4 NOT NULL,
  "provider" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "prompt" text COLLATE "pg_catalog"."default" NOT NULL,
  "model" varchar(100) COLLATE "pg_catalog"."default",
  "duration" int4,
  "video_url" varchar(500) COLLATE "pg_catalog"."default",
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'pending'::character varying,
  "task_id" varchar(100) COLLATE "pg_catalog"."default",
  "error_msg" text COLLATE "pg_catalog"."default",
  "created_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "completed_at" timestamptz(6),
  "deleted_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of video_generations
-- ----------------------------

-- ----------------------------
-- Table structure for video_merges
-- ----------------------------
DROP TABLE IF EXISTS "public"."video_merges";
CREATE TABLE "public"."video_merges" (
  "id" int4 NOT NULL DEFAULT nextval('video_merges_id_seq'::regclass),
  "episode_id" int4 NOT NULL,
  "drama_id" int4 NOT NULL,
  "title" varchar(200) COLLATE "pg_catalog"."default",
  "provider" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "model" varchar(100) COLLATE "pg_catalog"."default",
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'pending'::character varying,
  "scenes" jsonb NOT NULL,
  "merged_url" varchar(500) COLLATE "pg_catalog"."default",
  "duration" int4,
  "task_id" varchar(100) COLLATE "pg_catalog"."default",
  "error_msg" text COLLATE "pg_catalog"."default",
  "created_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "completed_at" timestamp(6),
  "deleted_at" timestamp(6)
)
;

-- ----------------------------
-- Records of video_merges
-- ----------------------------

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."ai_service_configs_id_seq"
OWNED BY "public"."ai_service_configs"."id";
SELECT setval('"public"."ai_service_configs_id_seq"', 1, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."ai_service_providers_id_seq"
OWNED BY "public"."ai_service_providers"."id";
SELECT setval('"public"."ai_service_providers_id_seq"', 6, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."asset_collections_id_seq"
OWNED BY "public"."asset_collections"."id";
SELECT setval('"public"."asset_collections_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."asset_tags_id_seq"
OWNED BY "public"."asset_tags"."id";
SELECT setval('"public"."asset_tags_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."assets_id_seq"
OWNED BY "public"."assets"."id";
SELECT setval('"public"."assets_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."async_tasks_id_seq"
OWNED BY "public"."async_tasks"."id";
SELECT setval('"public"."async_tasks_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."character_libraries_id_seq"
OWNED BY "public"."character_libraries"."id";
SELECT setval('"public"."character_libraries_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."characters_id_seq"
OWNED BY "public"."characters"."id";
SELECT setval('"public"."characters_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."clip_effects_id_seq"
OWNED BY "public"."clip_effects"."id";
SELECT setval('"public"."clip_effects_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."clip_transitions_id_seq"
OWNED BY "public"."clip_transitions"."id";
SELECT setval('"public"."clip_transitions_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."dramas_id_seq"
OWNED BY "public"."dramas"."id";
SELECT setval('"public"."dramas_id_seq"', 1, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."episodes_id_seq"
OWNED BY "public"."episodes"."id";
SELECT setval('"public"."episodes_id_seq"', 1, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."frame_prompts_id_seq"
OWNED BY "public"."frame_prompts"."id";
SELECT setval('"public"."frame_prompts_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."image_generations_id_seq"
OWNED BY "public"."image_generations"."id";
SELECT setval('"public"."image_generations_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."props_id_seq"
OWNED BY "public"."props"."id";
SELECT setval('"public"."props_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."scenes_id_seq"
OWNED BY "public"."scenes"."id";
SELECT setval('"public"."scenes_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."storyboards_id_seq"
OWNED BY "public"."storyboards"."id";
SELECT setval('"public"."storyboards_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."timeline_clips_id_seq"
OWNED BY "public"."timeline_clips"."id";
SELECT setval('"public"."timeline_clips_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."timeline_tracks_id_seq"
OWNED BY "public"."timeline_tracks"."id";
SELECT setval('"public"."timeline_tracks_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."timelines_id_seq"
OWNED BY "public"."timelines"."id";
SELECT setval('"public"."timelines_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."video_generations_id_seq"
OWNED BY "public"."video_generations"."id";
SELECT setval('"public"."video_generations_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."video_merges_id_seq"
OWNED BY "public"."video_merges"."id";
SELECT setval('"public"."video_merges_id_seq"', 1, false);

-- ----------------------------
-- Primary Key structure for table ai_service_configs
-- ----------------------------
ALTER TABLE "public"."ai_service_configs" ADD CONSTRAINT "ai_service_configs_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table ai_service_providers
-- ----------------------------
ALTER TABLE "public"."ai_service_providers" ADD CONSTRAINT "ai_service_providers_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table ai_service_providers
-- ----------------------------
ALTER TABLE "public"."ai_service_providers" ADD CONSTRAINT "ai_service_providers_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table asset_collection_relations
-- ----------------------------
CREATE INDEX "idx_asset_collection_relations_asset_id" ON "public"."asset_collection_relations" USING btree (
  "asset_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_asset_collection_relations_collection_id" ON "public"."asset_collection_relations" USING btree (
  "asset_collection_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table asset_collection_relations
-- ----------------------------
ALTER TABLE "public"."asset_collection_relations" ADD CONSTRAINT "asset_collection_relations_pkey" PRIMARY KEY ("asset_id", "asset_collection_id");

-- ----------------------------
-- Indexes structure for table asset_collections
-- ----------------------------
CREATE INDEX "idx_asset_collections_deleted_at" ON "public"."asset_collections" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_asset_collections_drama_id" ON "public"."asset_collections" USING btree (
  "drama_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table asset_collections
-- ----------------------------
ALTER TABLE "public"."asset_collections" ADD CONSTRAINT "asset_collections_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table asset_tag_relations
-- ----------------------------
CREATE INDEX "idx_asset_tag_relations_asset_id" ON "public"."asset_tag_relations" USING btree (
  "asset_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_asset_tag_relations_tag_id" ON "public"."asset_tag_relations" USING btree (
  "asset_tag_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table asset_tag_relations
-- ----------------------------
ALTER TABLE "public"."asset_tag_relations" ADD CONSTRAINT "asset_tag_relations_pkey" PRIMARY KEY ("asset_id", "asset_tag_id");

-- ----------------------------
-- Indexes structure for table asset_tags
-- ----------------------------
CREATE INDEX "idx_asset_tags_deleted_at" ON "public"."asset_tags" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table asset_tags
-- ----------------------------
ALTER TABLE "public"."asset_tags" ADD CONSTRAINT "asset_tags_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table assets
-- ----------------------------
CREATE INDEX "idx_assets_category" ON "public"."assets" USING btree (
  "category" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_assets_deleted_at" ON "public"."assets" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_assets_drama_id" ON "public"."assets" USING btree (
  "drama_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_assets_image_gen_id" ON "public"."assets" USING btree (
  "image_gen_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_assets_type" ON "public"."assets" USING btree (
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_assets_video_gen_id" ON "public"."assets" USING btree (
  "video_gen_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table assets
-- ----------------------------
ALTER TABLE "public"."assets" ADD CONSTRAINT "assets_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table async_tasks
-- ----------------------------
CREATE INDEX "idx_async_tasks_deleted_at" ON "public"."async_tasks" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_async_tasks_drama_id" ON "public"."async_tasks" USING btree (
  "drama_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_async_tasks_status" ON "public"."async_tasks" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_async_tasks_task_type" ON "public"."async_tasks" USING btree (
  "task_type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table async_tasks
-- ----------------------------
ALTER TABLE "public"."async_tasks" ADD CONSTRAINT "async_tasks_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table character_libraries
-- ----------------------------
CREATE INDEX "idx_character_libraries_category" ON "public"."character_libraries" USING btree (
  "category" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_character_libraries_deleted_at" ON "public"."character_libraries" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table character_libraries
-- ----------------------------
ALTER TABLE "public"."character_libraries" ADD CONSTRAINT "character_libraries_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table characters
-- ----------------------------
CREATE INDEX "idx_characters_deleted_at" ON "public"."characters" USING btree (
  "deleted_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
);
CREATE INDEX "idx_characters_drama_id" ON "public"."characters" USING btree (
  "drama_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table characters
-- ----------------------------
ALTER TABLE "public"."characters" ADD CONSTRAINT "characters_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table clip_effects
-- ----------------------------
CREATE INDEX "idx_clip_effects_clip_id" ON "public"."clip_effects" USING btree (
  "clip_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_clip_effects_deleted_at" ON "public"."clip_effects" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_clip_effects_type" ON "public"."clip_effects" USING btree (
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table clip_effects
-- ----------------------------
ALTER TABLE "public"."clip_effects" ADD CONSTRAINT "clip_effects_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table clip_transitions
-- ----------------------------
CREATE INDEX "idx_clip_transitions_deleted_at" ON "public"."clip_transitions" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_clip_transitions_type" ON "public"."clip_transitions" USING btree (
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table clip_transitions
-- ----------------------------
ALTER TABLE "public"."clip_transitions" ADD CONSTRAINT "clip_transitions_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table dramas
-- ----------------------------
CREATE INDEX "idx_dramas_deleted_at" ON "public"."dramas" USING btree (
  "deleted_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
);
CREATE INDEX "idx_dramas_status" ON "public"."dramas" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table dramas
-- ----------------------------
ALTER TABLE "public"."dramas" ADD CONSTRAINT "dramas_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table episode_characters
-- ----------------------------
ALTER TABLE "public"."episode_characters" ADD CONSTRAINT "episode_characters_pkey" PRIMARY KEY ("episode_id", "character_id");

-- ----------------------------
-- Indexes structure for table episodes
-- ----------------------------
CREATE INDEX "idx_episodes_deleted_at" ON "public"."episodes" USING btree (
  "deleted_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
);
CREATE INDEX "idx_episodes_drama_id" ON "public"."episodes" USING btree (
  "drama_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_episodes_status" ON "public"."episodes" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table episodes
-- ----------------------------
ALTER TABLE "public"."episodes" ADD CONSTRAINT "episodes_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table frame_prompts
-- ----------------------------
CREATE INDEX "idx_frame_prompts_deleted_at" ON "public"."frame_prompts" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_frame_prompts_drama_id" ON "public"."frame_prompts" USING btree (
  "drama_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_frame_prompts_episode_id" ON "public"."frame_prompts" USING btree (
  "episode_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_frame_prompts_storyboard_id" ON "public"."frame_prompts" USING btree (
  "storyboard_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table frame_prompts
-- ----------------------------
ALTER TABLE "public"."frame_prompts" ADD CONSTRAINT "frame_prompts_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table image_generations
-- ----------------------------
CREATE INDEX "idx_image_generations_status" ON "public"."image_generations" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table image_generations
-- ----------------------------
ALTER TABLE "public"."image_generations" ADD CONSTRAINT "image_generations_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table props
-- ----------------------------
CREATE INDEX "idx_props_deleted_at" ON "public"."props" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_props_drama_id" ON "public"."props" USING btree (
  "drama_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table props
-- ----------------------------
ALTER TABLE "public"."props" ADD CONSTRAINT "props_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table scenes
-- ----------------------------
CREATE INDEX "idx_scenes_drama_id" ON "public"."scenes" USING btree (
  "drama_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_scenes_episode_id" ON "public"."scenes" USING btree (
  "episode_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_scenes_status" ON "public"."scenes" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table scenes
-- ----------------------------
ALTER TABLE "public"."scenes" ADD CONSTRAINT "scenes_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table storyboard_characters
-- ----------------------------
CREATE INDEX "idx_storyboard_characters_character_id" ON "public"."storyboard_characters" USING btree (
  "character_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_storyboard_characters_storyboard_id" ON "public"."storyboard_characters" USING btree (
  "storyboard_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table storyboard_characters
-- ----------------------------
ALTER TABLE "public"."storyboard_characters" ADD CONSTRAINT "storyboard_characters_pkey" PRIMARY KEY ("storyboard_id", "character_id");

-- ----------------------------
-- Indexes structure for table storyboard_props
-- ----------------------------
CREATE INDEX "idx_storyboard_props_prop_id" ON "public"."storyboard_props" USING btree (
  "prop_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_storyboard_props_storyboard_id" ON "public"."storyboard_props" USING btree (
  "storyboard_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table storyboard_props
-- ----------------------------
ALTER TABLE "public"."storyboard_props" ADD CONSTRAINT "storyboard_props_pkey" PRIMARY KEY ("storyboard_id", "prop_id");

-- ----------------------------
-- Indexes structure for table storyboards
-- ----------------------------
CREATE INDEX "idx_storyboards_episode_id" ON "public"."storyboards" USING btree (
  "episode_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_storyboards_status" ON "public"."storyboards" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table storyboards
-- ----------------------------
ALTER TABLE "public"."storyboards" ADD CONSTRAINT "storyboards_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table timeline_clips
-- ----------------------------
CREATE INDEX "idx_timeline_clips_asset_id" ON "public"."timeline_clips" USING btree (
  "asset_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_timeline_clips_deleted_at" ON "public"."timeline_clips" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_timeline_clips_storyboard_id" ON "public"."timeline_clips" USING btree (
  "storyboard_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_timeline_clips_track_id" ON "public"."timeline_clips" USING btree (
  "track_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_timeline_clips_transition_in" ON "public"."timeline_clips" USING btree (
  "transition_in_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_timeline_clips_transition_out" ON "public"."timeline_clips" USING btree (
  "transition_out_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table timeline_clips
-- ----------------------------
ALTER TABLE "public"."timeline_clips" ADD CONSTRAINT "timeline_clips_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table timeline_tracks
-- ----------------------------
CREATE INDEX "idx_timeline_tracks_deleted_at" ON "public"."timeline_tracks" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_timeline_tracks_timeline_id" ON "public"."timeline_tracks" USING btree (
  "timeline_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_timeline_tracks_type" ON "public"."timeline_tracks" USING btree (
  "type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table timeline_tracks
-- ----------------------------
ALTER TABLE "public"."timeline_tracks" ADD CONSTRAINT "timeline_tracks_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table timelines
-- ----------------------------
CREATE INDEX "idx_timelines_deleted_at" ON "public"."timelines" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_timelines_drama_id" ON "public"."timelines" USING btree (
  "drama_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_timelines_episode_id" ON "public"."timelines" USING btree (
  "episode_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_timelines_status" ON "public"."timelines" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table timelines
-- ----------------------------
ALTER TABLE "public"."timelines" ADD CONSTRAINT "timelines_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table video_generations
-- ----------------------------
ALTER TABLE "public"."video_generations" ADD CONSTRAINT "video_generations_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table video_merges
-- ----------------------------
CREATE INDEX "idx_video_merges_deleted_at" ON "public"."video_merges" USING btree (
  "deleted_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "idx_video_merges_drama_id" ON "public"."video_merges" USING btree (
  "drama_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_video_merges_episode_id" ON "public"."video_merges" USING btree (
  "episode_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "idx_video_merges_status" ON "public"."video_merges" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table video_merges
-- ----------------------------
ALTER TABLE "public"."video_merges" ADD CONSTRAINT "video_merges_pkey" PRIMARY KEY ("id");
