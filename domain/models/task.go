package models

import (
	"database/sql"
	"time"
)

// AsyncTask 异步任务模型
type AsyncTask struct {
	ID           string       `json:"id" gorm:"primaryKey;type:varchar(64)"`
	Type         string       `json:"type" gorm:"type:varchar(50);not null;index:idx_async_tasks_type;comment:script_generation, image_generation, video_generation, etc."`
	DramaId      string       `json:"drama_id" gorm:"type:varchar(64);not null;default:'';index:idx_async_tasks_drama_id"`
	EpisodeId    string       `json:"episode_id" gorm:"type:varchar(64);not null;default:''"`
	StoryboardId string       `json:"storyboard_id" gorm:"type:varchar(64);not null;default:''"`
	PropId       string       `json:"prop_id" gorm:"type:varchar(64);not null;default:'';comment:道具图片任务id"`
	Status       string       `json:"status" gorm:"type:varchar(20);not null;default:'pending';index:idx_async_tasks_status;comment:pending, processing, completed, failed"`
	Progress     int          `json:"progress" gorm:"not null;default:0;comment:进度百分比 0-100"`
	Result       *string      `json:"result" gorm:"type:json"`
	Message      *string      `json:"message" gorm:"type:text"`
	CreatedAt    time.Time    `json:"created_at" gorm:"not null;default:CURRENT_TIMESTAMP"`
	UpdatedAt    time.Time    `json:"updated_at" gorm:"not null;default:CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"`
	CompletedAt  *time.Time   `json:"completed_at"`
	DeletedAt    sql.NullTime `json:"deleted_at" gorm:"index:idx_async_tasks_deleted_at"`
}

func (AsyncTask) TableName() string {
	return "async_tasks"
}
