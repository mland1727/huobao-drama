package ai

type CommonImageGenerationResponse struct {
	TaskID      string   `json:"task_id"`
	State       string   `json:"state"` // created, queueing, processing, success, failed
	Model       string   `json:"model"`
	Prompt      string   `json:"prompt"`
	Images      []string `json:"images"`
	Seed        int      `json:"seed"`
	AspectRatio string   `json:"aspect_ratio"`
	Resolution  string   `json:"resolution"`
	CallbackURL string   `json:"callback_url"`
	Payload     string   `json:"payload"`
	Credits     int      `json:"credits"`
	CreatedAt   string   `json:"created_at"`
}

// AIClient 定义文本生成客户端接口
type AIClient interface {
	GenerateText(prompt string, systemPrompt string, options ...func(*ChatCompletionRequest)) (string, error)
	// 图片生成接口
	GenerateImage(prompt string, size string, n int) ([]string, error)
	// 异步生成接口
	GenerateAsyncImage(prompt string, size string, n int) (*CommonImageGenerationResponse, error)
	TestConnection() error
}
