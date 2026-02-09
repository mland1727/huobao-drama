package image

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

type ViduClient struct {
	ctx        context.Context
	BaseURL    string
	APIKey     string
	Model      string
	HTTPClient *http.Client
}

// ViduImageGenerationRequest Vidu 图片生成请求
type ViduImageGenerationRequest struct {
	Model       string   `json:"model"`                  // 模型名称: viduq2, viduq1
	Images      []string `json:"images,omitempty"`       // 图像参考 (0-7张)
	Prompt      string   `json:"prompt"`                 // 文本提示词
	Seed        int      `json:"seed,omitempty"`         // 随机种子参数
	AspectRatio string   `json:"aspect_ratio,omitempty"` // 比例参数
	Resolution  string   `json:"resolution,omitempty"`   // 分辨率参数
	Payload     string   `json:"payload,omitempty"`      // 透传参数
	CallbackURL string   `json:"callback_url,omitempty"` // 回调URL
}

// ViduImageGenerationResponse Vidu 图片生成响应
type ViduImageGenerationResponse struct {
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

// ViduErrorResponse Vidu 错误响应
type ViduErrorResponse struct {
	Error struct {
		Message string `json:"message"`
		Type    string `json:"type"`
		Code    string `json:"code"`
	} `json:"error"`
}

type ViduTaskQueryResponse struct {
	ID        string `json:"id"`
	State     string `json:"state"`
	ErrCode   string `json:"err_code"`
	Credits   int    `json:"credits"`
	Payload   string `json:"payload"`
	Creations []struct {
		ID             string `json:"id"`
		URL            string `json:"url"`
		CoverURL       string `json:"cover_url"`
		WatermarkedURL string `json:"watermarked_url"`
	} `json:"creations"`
}

// NewViduImageClient 创建新的 Vidu 客户端
// model 模型名称 可选值：viduq2、viduq1;
// viduq2：支持文生图、图片编辑、参考生图 viduq1：支持参考生图
func NewViduImageClient(baseURL, apiKey, model, endpoint string) *ViduClient {
	if model == "" {
		model = "viduq2" // 默认使用 viduq2
	}
	if baseURL == "" {
		baseURL = "https://api.vidu.cn/ent/v2/"
	}

	return &ViduClient{
		ctx:     context.Background(),
		BaseURL: baseURL,
		APIKey:  apiKey,
		Model:   model,
		HTTPClient: &http.Client{
			Timeout: 30 * time.Second,
		},
	}
}

func (c *ViduClient) GenerateImage(prompt string, opts ...ImageOption) (*ImageResult, error) {
	options := &ImageOptions{}
	for _, opt := range opts {
		opt(options)
	}

	// 构建请求体
	req := ViduImageGenerationRequest{
		Model:  c.Model,
		Prompt: prompt,
	}

	// 设置参考图片
	if len(options.ReferenceImages) > 0 {
		req.Images = options.ReferenceImages
	}

	// 设置随机种子
	if options.Seed != 0 {
		req.Seed = int(options.Seed)
	}

	// 设置宽高比 (从 Size 或 Width/Height 推断)
	if options.Size != "" {
		req.AspectRatio = options.Size
	} else if options.Width > 0 && options.Height > 0 {
		// 根据宽高计算比例
		ratio := float64(options.Width) / float64(options.Height)
		switch {
		case ratio > 1.7 && ratio < 1.8:
			req.AspectRatio = "16:9"
		case ratio > 0.55 && ratio < 0.57:
			req.AspectRatio = "9:16"
		case ratio > 0.9 && ratio < 1.1:
			req.AspectRatio = "1:1"
		case ratio > 0.74 && ratio < 0.76:
			req.AspectRatio = "3:4"
		case ratio > 1.32 && ratio < 1.34:
			req.AspectRatio = "4:3"
		case ratio > 2.3 && ratio < 2.4:
			req.AspectRatio = "21:9"
		case ratio > 0.66 && ratio < 0.67:
			req.AspectRatio = "2:3"
		case ratio > 1.49 && ratio < 1.51:
			req.AspectRatio = "3:2"
		default:
			req.AspectRatio = "16:9" // 默认值
		}
	}

	// 设置分辨率
	if options.Quality != "" {
		req.Resolution = options.Quality
	} else {
		req.Resolution = "1080p" // 默认值
	}

	fmt.Printf("Vidu: 开始生成图片，prompt=%s, model=%s, aspect_ratio=%s, resolution=%s, images_count=%d\n",
		prompt, c.Model, req.AspectRatio, req.Resolution, len(req.Images))

	// 序列化请求体
	reqBody, err := json.Marshal(req)
	if err != nil {
		fmt.Printf("Vidu: 序列化请求失败: %v\n", err)
		return nil, fmt.Errorf("序列化请求失败: %w", err)
	}

	// 发送 HTTP 请求
	url := c.BaseURL + "reference2image"
	httpReq, err := http.NewRequestWithContext(c.ctx, "POST", url, nil)
	if err != nil {
		fmt.Printf("Vidu: 创建请求失败: %v\n", err)
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}

	httpReq.Header.Set("Content-Type", "application/json")
	httpReq.Header.Set("Authorization", "Token "+c.APIKey)
	httpReq.Body = io.NopCloser(bytes.NewReader(reqBody))

	resp, err := c.HTTPClient.Do(httpReq)
	if err != nil {
		fmt.Printf("Vidu: HTTP 请求失败: %v\n", err)
		return nil, fmt.Errorf("发送请求失败: %w", err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Printf("Vidu: 读取响应体失败: %v\n", err)
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		fmt.Printf("Vidu: API 错误 (状态码 %d): %s\n", resp.StatusCode, string(body))
		var errResp ViduErrorResponse
		if err := json.Unmarshal(body, &errResp); err == nil && errResp.Error.Message != "" {
			return nil, fmt.Errorf("API 错误: %s", errResp.Error.Message)
		}
		return nil, fmt.Errorf("API 错误 (状态码 %d): %s", resp.StatusCode, string(body))
	}

	var genResp ViduImageGenerationResponse
	if err := json.Unmarshal(body, &genResp); err != nil {
		fmt.Printf("Vidu: 解析响应失败: %v\n", err)
		return nil, fmt.Errorf("解析响应失败: %w", err)
	}

	fmt.Printf("Vidu: 图片生成任务已创建，task_id=%s, state=%s\n", genResp.TaskID, genResp.State)

	// 返回任务ID，状态为未完成
	return &ImageResult{
		TaskID:    genResp.TaskID,
		Status:    genResp.State,
		Completed: false,
	}, nil
}

// GetTaskStatus 查询任务状态
func (c *ViduClient) GetTaskStatus(taskID string) (*ImageResult, error) {
	endpoint := fmt.Sprintf("tasks/%s/creations", taskID)
	url := c.BaseURL + endpoint

	fmt.Printf("Vidu: 查询任务状态: %s\n", taskID)

	httpReq, err := http.NewRequestWithContext(c.ctx, "GET", url, nil)
	if err != nil {
		fmt.Printf("Vidu: 创建请求失败: %v\n", err)
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}

	httpReq.Header.Set("Authorization", "Token "+c.APIKey)

	resp, err := c.HTTPClient.Do(httpReq)
	if err != nil {
		fmt.Printf("Vidu: HTTP 请求失败: %v\n", err)
		return nil, fmt.Errorf("发送请求失败: %w", err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Printf("Vidu: 读取响应体失败: %v\n", err)
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		fmt.Printf("Vidu: API 错误 (状态码 %d): %s\n", resp.StatusCode, string(body))
		var errResp ViduErrorResponse
		if err := json.Unmarshal(body, &errResp); err == nil && errResp.Error.Message != "" {
			return nil, fmt.Errorf("API 错误: %s", errResp.Error.Message)
		}
		return nil, fmt.Errorf("API 错误 (状态码 %d): %s", resp.StatusCode, string(body))
	}

	var taskResp ViduTaskQueryResponse
	if err := json.Unmarshal(body, &taskResp); err != nil {
		fmt.Printf("Vidu: 解析响应失败: %v, body=%s\n", err, string(body))
		return nil, fmt.Errorf("解析响应失败: %w", err)
	}

	fmt.Printf("Vidu: 任务状态=%s, creations_count=%d\n", taskResp.State, len(taskResp.Creations))

	result := &ImageResult{
		TaskID: taskResp.ID,
		Status: taskResp.State,
	}

	// 判断任务是否完成
	switch taskResp.State {
	case "success":
		result.Completed = true
		// 获取第一个生成物的URL
		if len(taskResp.Creations) > 0 {
			// 循环查找第一个有效URL
			for _, creation := range taskResp.Creations {
				if creation.URL != "" {
					result.ImageURL = creation.URL
					break
				}
			}
			// 如果没有找到有效URL，则使用第一个的URL（可能为空）
			if result.ImageURL == "" {
				result.ImageURL = taskResp.Creations[0].URL
			}
			fmt.Printf("Vidu: 任务完成，图片URL=%s\n", result.ImageURL)
		}
	case "failed":
		result.Completed = true
		if taskResp.ErrCode != "" {
			result.Error = fmt.Sprintf("任务失败，错误码: %s", taskResp.ErrCode)
		} else {
			result.Error = "任务失败"
		}
		fmt.Printf("Vidu: %s\n", result.Error)
	default:
		// created, queueing, processing
		result.Completed = false
		fmt.Printf("Vidu: 任务处理中，状态=%s\n", taskResp.State)
	}

	return result, nil
}
