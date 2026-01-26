-- AI短剧生成平台 - PostgreSQL数据库初始化脚本 (开源版本 - 无用户认证)
-- 创建时间: 2026-01-26
-- 说明: 此版本适配PostgreSQL，移除外键约束，适合单机部署

-- ======================================
-- 1. 剧本相关表
-- ======================================

-- 剧本表
CREATE TABLE IF NOT EXISTS dramas (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    genre VARCHAR(50),
    style VARCHAR(50) NOT NULL DEFAULT 'realistic',
    total_episodes INTEGER NOT NULL DEFAULT 1,
    total_duration INTEGER NOT NULL DEFAULT 0, -- 总时长(秒)
    status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, in_progress, completed
    thumbnail VARCHAR(500),
    tags JSONB, -- JSON存储
    metadata JSONB, -- JSON存储
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_dramas_status ON dramas(status);
CREATE INDEX IF NOT EXISTS idx_dramas_deleted_at ON dramas(deleted_at);

-- 章节表
CREATE TABLE IF NOT EXISTS episodes (
    id SERIAL PRIMARY KEY,
    drama_id INTEGER NOT NULL,
    episode_number INTEGER NOT NULL,
    title VARCHAR(200) NOT NULL,
    script_content TEXT,
    description TEXT,
    duration INTEGER NOT NULL DEFAULT 0, -- 时长(秒)
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    video_url VARCHAR(500),
    thumbnail VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_episodes_drama_id ON episodes(drama_id);
CREATE INDEX IF NOT EXISTS idx_episodes_status ON episodes(status);
CREATE INDEX IF NOT EXISTS idx_episodes_deleted_at ON episodes(deleted_at);

-- 角色表
CREATE TABLE IF NOT EXISTS characters (
    id SERIAL PRIMARY KEY,
    drama_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50),
    description TEXT,
    appearance TEXT,
    personality TEXT,
    voice_style VARCHAR(200),
    image_url VARCHAR(500),
    reference_images JSONB, -- JSON存储
    seed_value VARCHAR(100),
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_characters_drama_id ON characters(drama_id);
CREATE INDEX IF NOT EXISTS idx_characters_deleted_at ON characters(deleted_at);

-- 章节-角色关联表 (多对多)
CREATE TABLE IF NOT EXISTS episode_characters (
    episode_id INTEGER NOT NULL,
    character_id INTEGER NOT NULL,
    PRIMARY KEY (episode_id, character_id)
);

CREATE INDEX IF NOT EXISTS idx_episode_characters_episode_id ON episode_characters(episode_id);
CREATE INDEX IF NOT EXISTS idx_episode_characters_character_id ON episode_characters(character_id);

-- 场景表
CREATE TABLE IF NOT EXISTS scenes (
    id SERIAL PRIMARY KEY,
    drama_id INTEGER NOT NULL,
    episode_id INTEGER,
    location VARCHAR(200) NOT NULL,
    time VARCHAR(100) NOT NULL,
    prompt TEXT NOT NULL,
    storyboard_count INTEGER NOT NULL DEFAULT 1,
    image_url VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, generated, failed
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_scenes_drama_id ON scenes(drama_id);
CREATE INDEX IF NOT EXISTS idx_scenes_episode_id ON scenes(episode_id);
CREATE INDEX IF NOT EXISTS idx_scenes_status ON scenes(status);
CREATE INDEX IF NOT EXISTS idx_scenes_deleted_at ON scenes(deleted_at);

-- 道具表
CREATE TABLE IF NOT EXISTS props (
    id SERIAL PRIMARY KEY,
    drama_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    description TEXT,
    prompt TEXT,
    image_url VARCHAR(500),
    reference_images JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_props_drama_id ON props(drama_id);
CREATE INDEX IF NOT EXISTS idx_props_deleted_at ON props(deleted_at);

-- 分镜表
CREATE TABLE IF NOT EXISTS storyboards (
    id SERIAL PRIMARY KEY,
    episode_id INTEGER NOT NULL,
    scene_id INTEGER,
    storyboard_number INTEGER NOT NULL,
    title VARCHAR(255),
    description TEXT,
    location VARCHAR(255),
    time VARCHAR(255),
    shot_type VARCHAR(100),
    angle VARCHAR(100),
    movement VARCHAR(100),
    action TEXT,
    result TEXT,
    atmosphere TEXT,
    image_prompt TEXT,
    video_prompt TEXT,
    bgm_prompt TEXT,
    sound_effect VARCHAR(255),
    dialogue TEXT,
    duration INTEGER NOT NULL DEFAULT 5, -- 时长(秒)
    composed_image TEXT,
    video_url TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, processing, completed, failed
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_storyboards_episode_id ON storyboards(episode_id);
CREATE INDEX IF NOT EXISTS idx_storyboards_scene_id ON storyboards(scene_id);
CREATE INDEX IF NOT EXISTS idx_storyboards_storyboard_number ON storyboards(storyboard_number);
CREATE INDEX IF NOT EXISTS idx_storyboards_status ON storyboards(status);
CREATE INDEX IF NOT EXISTS idx_storyboards_deleted_at ON storyboards(deleted_at);

-- 分镜-角色关联表 (多对多)
CREATE TABLE IF NOT EXISTS storyboard_characters (
    storyboard_id INTEGER NOT NULL,
    character_id INTEGER NOT NULL,
    PRIMARY KEY (storyboard_id, character_id)
);

CREATE INDEX IF NOT EXISTS idx_storyboard_characters_storyboard_id ON storyboard_characters(storyboard_id);
CREATE INDEX IF NOT EXISTS idx_storyboard_characters_character_id ON storyboard_characters(character_id);

-- 分镜-道具关联表 (多对多)
CREATE TABLE IF NOT EXISTS storyboard_props (
    storyboard_id INTEGER NOT NULL,
    prop_id INTEGER NOT NULL,
    PRIMARY KEY (storyboard_id, prop_id)
);

CREATE INDEX IF NOT EXISTS idx_storyboard_props_storyboard_id ON storyboard_props(storyboard_id);
CREATE INDEX IF NOT EXISTS idx_storyboard_props_prop_id ON storyboard_props(prop_id);

-- ======================================
-- 2. AI生成相关表
-- ======================================

-- 图片生成记录表
CREATE TABLE IF NOT EXISTS image_generations (
    id SERIAL PRIMARY KEY,
    storyboard_id INTEGER,
    drama_id INTEGER NOT NULL,
    provider VARCHAR(50) NOT NULL, -- openai, midjourney, stable_diffusion
    prompt TEXT NOT NULL,
    negative_prompt TEXT,
    model VARCHAR(100),
    size VARCHAR(20),
    quality VARCHAR(20),
    style VARCHAR(50),
    steps INTEGER,
    cfg_scale DECIMAL(4,2),
    seed BIGINT,
    image_url VARCHAR(500),
    minio_url VARCHAR(500),
    local_path VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, processing, completed, failed
    task_id VARCHAR(100),
    error_msg TEXT,
    width INTEGER,
    height INTEGER,
    reference_images JSONB, -- JSON存储
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_image_generations_storyboard_id ON image_generations(storyboard_id);
CREATE INDEX IF NOT EXISTS idx_image_generations_drama_id ON image_generations(drama_id);
CREATE INDEX IF NOT EXISTS idx_image_generations_status ON image_generations(status);
CREATE INDEX IF NOT EXISTS idx_image_generations_task_id ON image_generations(task_id);
CREATE INDEX IF NOT EXISTS idx_image_generations_deleted_at ON image_generations(deleted_at);

-- 视频生成记录表
CREATE TABLE IF NOT EXISTS video_generations (
    id SERIAL PRIMARY KEY,
    storyboard_id INTEGER,
    drama_id INTEGER NOT NULL,
    provider VARCHAR(50) NOT NULL, -- runway, pika, doubao, openai
    prompt TEXT NOT NULL,
    model VARCHAR(100),
    image_gen_id INTEGER,
    image_url VARCHAR(500),
    first_frame_url VARCHAR(500),
    duration INTEGER, -- 时长(秒)
    fps INTEGER,
    resolution VARCHAR(20),
    aspect_ratio VARCHAR(10),
    style VARCHAR(50),
    motion_level INTEGER,
    camera_motion VARCHAR(100),
    seed BIGINT,
    video_url VARCHAR(500),
    minio_url VARCHAR(500),
    local_path VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, processing, completed, failed
    task_id VARCHAR(100),
    error_msg TEXT,
    completed_at TIMESTAMP,
    width INTEGER,
    height INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_video_generations_storyboard_id ON video_generations(storyboard_id);
CREATE INDEX IF NOT EXISTS idx_video_generations_drama_id ON video_generations(drama_id);
CREATE INDEX IF NOT EXISTS idx_video_generations_provider ON video_generations(provider);
CREATE INDEX IF NOT EXISTS idx_video_generations_status ON video_generations(status);
CREATE INDEX IF NOT EXISTS idx_video_generations_task_id ON video_generations(task_id);
CREATE INDEX IF NOT EXISTS idx_video_generations_image_gen_id ON video_generations(image_gen_id);
CREATE INDEX IF NOT EXISTS idx_video_generations_deleted_at ON video_generations(deleted_at);

-- 视频合成记录表
CREATE TABLE IF NOT EXISTS video_merges (
    id SERIAL PRIMARY KEY,
    episode_id INTEGER NOT NULL,
    drama_id INTEGER NOT NULL,
    title VARCHAR(200),
    provider VARCHAR(50) NOT NULL,
    model VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, processing, completed, failed
    scenes JSONB NOT NULL, -- JSON存储：场景片段列表
    merged_url VARCHAR(500),
    duration INTEGER, -- 总时长(秒)
    task_id VARCHAR(100),
    error_msg TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_video_merges_episode_id ON video_merges(episode_id);
CREATE INDEX IF NOT EXISTS idx_video_merges_drama_id ON video_merges(drama_id);
CREATE INDEX IF NOT EXISTS idx_video_merges_status ON video_merges(status);
CREATE INDEX IF NOT EXISTS idx_video_merges_deleted_at ON video_merges(deleted_at);

-- ======================================
-- 3. 角色库表
-- ======================================

-- 角色库表 (开源版本 - 全局共享)
CREATE TABLE IF NOT EXISTS character_libraries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    image_url VARCHAR(500) NOT NULL,
    description TEXT,
    tags VARCHAR(500),
    source_type VARCHAR(20) NOT NULL DEFAULT 'generated', -- generated, uploaded
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_character_libraries_category ON character_libraries(category);
CREATE INDEX IF NOT EXISTS idx_character_libraries_deleted_at ON character_libraries(deleted_at);

-- 帧提示词表
CREATE TABLE IF NOT EXISTS frame_prompts (
    id SERIAL PRIMARY KEY,
    drama_id INTEGER NOT NULL,
    episode_id INTEGER,
    storyboard_id INTEGER,
    frame_type VARCHAR(20) NOT NULL, -- shot, scene, transition
    frame_number INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    negative_prompt TEXT,
    reference_image VARCHAR(500),
    generated_image VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_frame_prompts_drama_id ON frame_prompts(drama_id);
CREATE INDEX IF NOT EXISTS idx_frame_prompts_episode_id ON frame_prompts(episode_id);
CREATE INDEX IF NOT EXISTS idx_frame_prompts_storyboard_id ON frame_prompts(storyboard_id);
CREATE INDEX IF NOT EXISTS idx_frame_prompts_deleted_at ON frame_prompts(deleted_at);

-- ======================================
-- 4. 时间线相关表
-- ======================================

-- 时间线表
CREATE TABLE IF NOT EXISTS timelines (
    id SERIAL PRIMARY KEY,
    drama_id INTEGER NOT NULL,
    episode_id INTEGER,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    duration INTEGER NOT NULL DEFAULT 0, -- 总时长(秒)
    fps INTEGER NOT NULL DEFAULT 30,
    resolution VARCHAR(20),
    status VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, editing, completed, exporting
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_timelines_drama_id ON timelines(drama_id);
CREATE INDEX IF NOT EXISTS idx_timelines_episode_id ON timelines(episode_id);
CREATE INDEX IF NOT EXISTS idx_timelines_status ON timelines(status);
CREATE INDEX IF NOT EXISTS idx_timelines_deleted_at ON timelines(deleted_at);

-- 时间线轨道表
CREATE TABLE IF NOT EXISTS timeline_tracks (
    id SERIAL PRIMARY KEY,
    timeline_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL, -- video, audio, text
    track_order INTEGER NOT NULL DEFAULT 0,
    is_locked BOOLEAN NOT NULL DEFAULT FALSE,
    is_muted BOOLEAN NOT NULL DEFAULT FALSE,
    volume INTEGER DEFAULT 100,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_timeline_tracks_timeline_id ON timeline_tracks(timeline_id);
CREATE INDEX IF NOT EXISTS idx_timeline_tracks_type ON timeline_tracks(type);
CREATE INDEX IF NOT EXISTS idx_timeline_tracks_deleted_at ON timeline_tracks(deleted_at);

-- 时间线片段表
CREATE TABLE IF NOT EXISTS timeline_clips (
    id SERIAL PRIMARY KEY,
    track_id INTEGER NOT NULL,
    asset_id INTEGER,
    storyboard_id INTEGER,
    name VARCHAR(200),
    start_time BIGINT NOT NULL, -- 开始时间(毫秒)
    end_time BIGINT NOT NULL, -- 结束时间(毫秒)
    duration BIGINT NOT NULL, -- 时长(毫秒)
    trim_start BIGINT, -- 裁剪开始(毫秒)
    trim_end BIGINT, -- 裁剪结束(毫秒)
    speed DECIMAL(4,2) DEFAULT 1.0,
    volume INTEGER,
    is_muted BOOLEAN NOT NULL DEFAULT FALSE,
    fade_in BIGINT, -- 淡入时长(毫秒)
    fade_out BIGINT, -- 淡出时长(毫秒)
    transition_in_id INTEGER,
    transition_out_id INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_timeline_clips_track_id ON timeline_clips(track_id);
CREATE INDEX IF NOT EXISTS idx_timeline_clips_asset_id ON timeline_clips(asset_id);
CREATE INDEX IF NOT EXISTS idx_timeline_clips_storyboard_id ON timeline_clips(storyboard_id);
CREATE INDEX IF NOT EXISTS idx_timeline_clips_transition_in ON timeline_clips(transition_in_id);
CREATE INDEX IF NOT EXISTS idx_timeline_clips_transition_out ON timeline_clips(transition_out_id);
CREATE INDEX IF NOT EXISTS idx_timeline_clips_deleted_at ON timeline_clips(deleted_at);

-- 片段转场表
CREATE TABLE IF NOT EXISTS clip_transitions (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL, -- fade, crossfade, slide, wipe, zoom, dissolve
    duration INTEGER NOT NULL DEFAULT 500, -- 转场时长(毫秒)
    easing VARCHAR(50),
    config JSONB, -- JSON存储
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_clip_transitions_type ON clip_transitions(type);
CREATE INDEX IF NOT EXISTS idx_clip_transitions_deleted_at ON clip_transitions(deleted_at);

-- 片段效果表
CREATE TABLE IF NOT EXISTS clip_effects (
    id SERIAL PRIMARY KEY,
    clip_id INTEGER NOT NULL,
    type VARCHAR(50) NOT NULL, -- filter, color, blur, brightness, contrast, saturation
    name VARCHAR(100),
    is_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    effect_order INTEGER NOT NULL DEFAULT 0,
    config JSONB, -- JSON存储
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_clip_effects_clip_id ON clip_effects(clip_id);
CREATE INDEX IF NOT EXISTS idx_clip_effects_type ON clip_effects(type);
CREATE INDEX IF NOT EXISTS idx_clip_effects_deleted_at ON clip_effects(deleted_at);

-- ======================================
-- 5. 资源管理相关表
-- ======================================

-- 资源表
CREATE TABLE IF NOT EXISTS assets (
    id SERIAL PRIMARY KEY,
    drama_id INTEGER,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    type VARCHAR(20) NOT NULL, -- image, video, audio
    category VARCHAR(50),
    url VARCHAR(500) NOT NULL,
    thumbnail_url VARCHAR(500),
    local_path VARCHAR(500),
    file_size BIGINT,
    mime_type VARCHAR(100),
    width INTEGER,
    height INTEGER,
    duration INTEGER, -- 时长(秒)
    format VARCHAR(20),
    image_gen_id INTEGER,
    video_gen_id INTEGER,
    is_favorite BOOLEAN NOT NULL DEFAULT FALSE,
    view_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_assets_drama_id ON assets(drama_id);
CREATE INDEX IF NOT EXISTS idx_assets_type ON assets(type);
CREATE INDEX IF NOT EXISTS idx_assets_category ON assets(category);
CREATE INDEX IF NOT EXISTS idx_assets_image_gen_id ON assets(image_gen_id);
CREATE INDEX IF NOT EXISTS idx_assets_video_gen_id ON assets(video_gen_id);
CREATE INDEX IF NOT EXISTS idx_assets_deleted_at ON assets(deleted_at);

-- 资源标签表
CREATE TABLE IF NOT EXISTS asset_tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    color VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_asset_tags_deleted_at ON asset_tags(deleted_at);

-- 资源集合表
CREATE TABLE IF NOT EXISTS asset_collections (
    id SERIAL PRIMARY KEY,
    drama_id INTEGER,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_asset_collections_drama_id ON asset_collections(drama_id);
CREATE INDEX IF NOT EXISTS idx_asset_collections_deleted_at ON asset_collections(deleted_at);

-- 资源标签关系表(多对多)
CREATE TABLE IF NOT EXISTS asset_tag_relations (
    asset_id INTEGER NOT NULL,
    asset_tag_id INTEGER NOT NULL,
    PRIMARY KEY (asset_id, asset_tag_id)
);

CREATE INDEX IF NOT EXISTS idx_asset_tag_relations_asset_id ON asset_tag_relations(asset_id);
CREATE INDEX IF NOT EXISTS idx_asset_tag_relations_tag_id ON asset_tag_relations(asset_tag_id);

-- 资源集合关系表(多对多)
CREATE TABLE IF NOT EXISTS asset_collection_relations (
    asset_id INTEGER NOT NULL,
    asset_collection_id INTEGER NOT NULL,
    PRIMARY KEY (asset_id, asset_collection_id)
);

CREATE INDEX IF NOT EXISTS idx_asset_collection_relations_asset_id ON asset_collection_relations(asset_id);
CREATE INDEX IF NOT EXISTS idx_asset_collection_relations_collection_id ON asset_collection_relations(asset_collection_id);

-- ======================================
-- 6. AI服务配置表 (开源版本 - 全局配置)
-- ======================================

-- AI服务配置表 (全局配置，无用户隔离)
CREATE TABLE IF NOT EXISTS ai_service_configs (
    id SERIAL PRIMARY KEY,
    service_type VARCHAR(20) NOT NULL, -- text, image, video
    provider VARCHAR(50), -- openai, gemini, volcengine, etc.
    name VARCHAR(100) NOT NULL,
    base_url VARCHAR(500) NOT NULL,
    api_key VARCHAR(500) NOT NULL,
    model VARCHAR(100),
    endpoint VARCHAR(500),
    query_endpoint VARCHAR(500),
    priority INTEGER NOT NULL DEFAULT 0,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    settings JSONB, -- JSON存储
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_ai_service_configs_service_type ON ai_service_configs(service_type);
CREATE INDEX IF NOT EXISTS idx_ai_service_configs_deleted_at ON ai_service_configs(deleted_at);

-- AI服务提供商表
CREATE TABLE IF NOT EXISTS ai_service_providers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    service_type VARCHAR(20) NOT NULL, -- text, image, video
    default_url VARCHAR(500),
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_ai_service_providers_service_type ON ai_service_providers(service_type);
CREATE INDEX IF NOT EXISTS idx_ai_service_providers_deleted_at ON ai_service_providers(deleted_at);

-- 异步任务表
CREATE TABLE IF NOT EXISTS async_tasks (
    id SERIAL PRIMARY KEY,
    task_type VARCHAR(50) NOT NULL, -- image_generation, video_generation, video_merge
    drama_id INTEGER,
    episode_id INTEGER,
    storyboard_id INTEGER,
    status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, processing, completed, failed
    progress INTEGER NOT NULL DEFAULT 0, -- 进度 0-100
    result JSONB, -- 任务结果
    error_msg TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_async_tasks_task_type ON async_tasks(task_type);
CREATE INDEX IF NOT EXISTS idx_async_tasks_status ON async_tasks(status);
CREATE INDEX IF NOT EXISTS idx_async_tasks_drama_id ON async_tasks(drama_id);
CREATE INDEX IF NOT EXISTS idx_async_tasks_deleted_at ON async_tasks(deleted_at);

-- ======================================
-- 7. 初始数据
-- ======================================

-- 插入默认AI服务提供商
INSERT INTO ai_service_providers (name, display_name, service_type, default_url, description) VALUES
('openai', 'OpenAI', 'text', 'https://api.openai.com/v1', 'OpenAI GPT模型'),
('openai-dalle', 'OpenAI DALL-E', 'image', 'https://api.openai.com/v1', 'OpenAI DALL-E图片生成'),
('openai-sora', 'OpenAI Sora', 'video', 'https://api.openai.com/v1', 'OpenAI Sora视频生成'),
('midjourney', 'Midjourney', 'image', '', 'Midjourney图片生成'),
('doubao-image', '豆包(火山引擎)', 'image', 'https://ark.cn-beijing.volces.com', '火山引擎豆包图片生成'),
('gemini-image', 'Google Gemini', 'image', 'https://generativelanguage.googleapis.com', 'Google Gemini原生图片生成(base64)'),
('runway', 'Runway', 'video', '', 'Runway视频生成'),
('pika', 'Pika Labs', 'video', '', 'Pika视频生成'),
('doubao', '豆包(火山引擎)', 'video', 'https://ark.cn-beijing.volces.com', '火山引擎豆包视频生成'),
('minimax', 'MiniMax', 'video', '', 'MiniMax视频生成')
ON CONFLICT (name) DO NOTHING;