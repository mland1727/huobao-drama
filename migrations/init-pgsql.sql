-- =====================================================
-- AI短剧生成平台 - PostgreSQL 初始化脚本（最终版）
-- 时间字段统一使用 TIMESTAMPTZ
-- 无外键设计，适合 AI 异步生成流水线
-- =====================================================

SET timezone = 'UTC';

-- =====================================================
-- 1. 剧本相关
-- =====================================================

DROP TABLE IF EXISTS dramas CASCADE;
CREATE TABLE dramas (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    genre VARCHAR(50),
    style VARCHAR(50) NOT NULL DEFAULT 'realistic',
    total_episodes INTEGER NOT NULL DEFAULT 1,
    total_duration INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    thumbnail VARCHAR(500),
    tags JSONB,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_dramas_status ON dramas(status);
CREATE INDEX idx_dramas_deleted_at ON dramas(deleted_at);

-- =====================================================
-- 章节
-- =====================================================

DROP TABLE IF EXISTS episodes CASCADE;
CREATE TABLE episodes (
    id SERIAL PRIMARY KEY,
    drama_id INTEGER NOT NULL,
    episode_number INTEGER NOT NULL,
    title VARCHAR(200) NOT NULL,
    script_content TEXT,
    description TEXT,
    duration INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    video_url VARCHAR(500),
    thumbnail VARCHAR(500),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_episodes_drama_id ON episodes(drama_id);
CREATE INDEX idx_episodes_status ON episodes(status);
CREATE INDEX idx_episodes_deleted_at ON episodes(deleted_at);

-- =====================================================
-- 角色
-- =====================================================

DROP TABLE IF EXISTS characters CASCADE;
CREATE TABLE characters (
    id SERIAL PRIMARY KEY,
    drama_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50),
    description TEXT,
    appearance TEXT,
    personality TEXT,
    voice_style VARCHAR(200),
    image_url VARCHAR(500),
    reference_images JSONB,
    seed_value VARCHAR(100),
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_characters_drama_id ON characters(drama_id);
CREATE INDEX idx_characters_deleted_at ON characters(deleted_at);

-- =====================================================
-- 章节-角色
-- =====================================================

DROP TABLE IF EXISTS episode_characters CASCADE;
CREATE TABLE episode_characters (
    episode_id INTEGER NOT NULL,
    character_id INTEGER NOT NULL,
    PRIMARY KEY (episode_id, character_id)
);

-- =====================================================
-- 场景
-- =====================================================

DROP TABLE IF EXISTS scenes CASCADE;
CREATE TABLE scenes (
    id SERIAL PRIMARY KEY,
    drama_id INTEGER NOT NULL,
    episode_id INTEGER,
    location VARCHAR(200) NOT NULL,
    time VARCHAR(100) NOT NULL,
    prompt TEXT NOT NULL,
    storyboard_count INTEGER NOT NULL DEFAULT 1,
    image_url VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_scenes_drama_id ON scenes(drama_id);
CREATE INDEX idx_scenes_episode_id ON scenes(episode_id);
CREATE INDEX idx_scenes_status ON scenes(status);

-- =====================================================
-- 分镜
-- =====================================================

DROP TABLE IF EXISTS storyboards CASCADE;
CREATE TABLE storyboards (
    id SERIAL PRIMARY KEY,
    episode_id INTEGER NOT NULL,
    scene_id INTEGER,
    storyboard_number INTEGER NOT NULL,
    title VARCHAR(255),
    description TEXT,
    action TEXT,
    dialogue TEXT,
    image_prompt TEXT,
    video_prompt TEXT,
    duration INTEGER NOT NULL DEFAULT 5,
    composed_image TEXT,
    video_url TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_storyboards_episode_id ON storyboards(episode_id);
CREATE INDEX idx_storyboards_status ON storyboards(status);

-- =====================================================
-- 2. AI 生成
-- =====================================================

DROP TABLE IF EXISTS image_generations CASCADE;
CREATE TABLE image_generations (
    id SERIAL PRIMARY KEY,
    storyboard_id INTEGER,
    drama_id INTEGER NOT NULL,
    provider VARCHAR(50) NOT NULL,
    prompt TEXT NOT NULL,
    negative_prompt TEXT,
    model VARCHAR(100),
    image_url VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    task_id VARCHAR(100),
    error_msg TEXT,
    reference_images JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_image_generations_status ON image_generations(status);

DROP TABLE IF EXISTS video_generations CASCADE;
CREATE TABLE video_generations (
    id SERIAL PRIMARY KEY,
    storyboard_id INTEGER,
    drama_id INTEGER NOT NULL,
    provider VARCHAR(50) NOT NULL,
    prompt TEXT NOT NULL,
    model VARCHAR(100),
    duration INTEGER,
    video_url VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    task_id VARCHAR(100),
    error_msg TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
);

-- =====================================================
-- 3. AI 服务配置
-- =====================================================

DROP TABLE IF EXISTS ai_service_configs CASCADE;
CREATE TABLE ai_service_configs (
    id SERIAL PRIMARY KEY,
    service_type VARCHAR(20) NOT NULL,
    provider VARCHAR(50),
    name VARCHAR(100) NOT NULL,
    base_url VARCHAR(500) NOT NULL,
    api_key VARCHAR(500) NOT NULL,
    model JSONB,
    endpoint VARCHAR(500),
    query_endpoint VARCHAR(500),
    priority INTEGER NOT NULL DEFAULT 0,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    settings JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);

DROP TABLE IF EXISTS ai_service_providers CASCADE;
CREATE TABLE ai_service_providers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    service_type VARCHAR(20) NOT NULL,
    default_url VARCHAR(500),
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);

-- =====================================================
-- 初始数据
-- =====================================================

INSERT INTO ai_service_providers
(name, display_name, service_type, default_url, description)
VALUES
('openai', 'OpenAI', 'text', 'https://api.openai.com/v1', 'OpenAI GPT模型'),
('openai-dalle', 'OpenAI DALL-E', 'image', 'https://api.openai.com/v1', 'OpenAI 图片生成'),
('openai-sora', 'OpenAI Sora', 'video', 'https://api.openai.com/v1', 'OpenAI 视频生成'),
('midjourney', 'Midjourney', 'image', '', 'Midjourney 图片生成'),
('gemini', 'Google Gemini', 'text', 'https://generativelanguage.googleapis.com', 'Gemini 文本生成'),
('runway', 'Runway', 'video', '', 'Runway 视频生成')
ON CONFLICT (name) DO NOTHING;
