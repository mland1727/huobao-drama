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
	baseURL = "https://api.vidu.cn/ent/v2/"

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

	// 打印提示词
	fmt.Printf("Vidu: 生成图片请求，prompt=%s, model=%s\n", prompt, c.Model)

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

	// 设置宽高比 - 解析 Size 字段
	if options.Size != "" {
		// 如果 Size 已经是比例格式（如 "16:9"），直接使用
		if isAspectRatioFormat(options.Size) {
			req.AspectRatio = options.Size
		} else {
			// 如果是分辨率格式（如 "2560x1440"），转换为比例
			req.AspectRatio = parseResolutionToAspectRatio(options.Size)
		}
	} else if options.Width > 0 && options.Height > 0 {
		// 根据宽高计算比例
		req.AspectRatio = calculateAspectRatio(options.Width, options.Height)
	} else {
		req.AspectRatio = "16:9" // 默认值
	}

	// 设置分辨率
	// viduq1: 默认1080p，可选项：1080p
	// viduq2: 默认1080p，可选项：1080p、2K、4K
	if options.Quality != "" {
		req.Resolution = normalizeResolution(options.Quality)
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
	fmt.Printf("Vidu: 请求图片生成API地址: %v\n", url)
	httpReq, err := http.NewRequestWithContext(c.ctx, "POST", url, nil)
	if err != nil {
		fmt.Printf("Vidu: 创建请求失败: %v\n", err)
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}

	httpReq.Header.Set("Content-Type", "application/json")
	httpReq.Header.Set("Authorization", "Token "+c.APIKey)
	httpReq.Body = io.NopCloser(bytes.NewReader(reqBody))

	// 打印请求header和body
	fmt.Printf("Vidu: 请求Header: %v\n", httpReq.Header)
	fmt.Printf("Vidu: 请求Body: %s\n", string(reqBody))

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

	// Vidu: 图片生成任务已创建，task_id=918444265841922048, state=created
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

// isAspectRatioFormat 检查字符串是否为比例格式（如 "16:9"）
func isAspectRatioFormat(s string) bool {
	validRatios := map[string]bool{
		"16:9": true, "9:16": true, "1:1": true,
		"3:4": true, "4:3": true, "21:9": true,
		"2:3": true, "3:2": true, "4:5": true,
		"5:4": true, "9:21": true,
	}
	return validRatios[s]
}

// parseResolutionToAspectRatio 将分辨率格式转换为比例格式
func parseResolutionToAspectRatio(size string) string {
	// 尝试解析 "WxH" 格式
	var width, height int
	if _, err := fmt.Sscanf(size, "%dx%d", &width, &height); err == nil && width > 0 && height > 0 {
		return calculateAspectRatio(width, height)
	}
	// 默认返回 16:9
	return "16:9"
}

// calculateAspectRatio 根据宽高计算最接近的标准比例
func calculateAspectRatio(width, height int) string {
	ratio := float64(width) / float64(height)

	// 定义标准比例及其数值
	ratios := []struct {
		name  string
		value float64
	}{
		{"21:9", 21.0 / 9.0}, // 2.333
		{"16:9", 16.0 / 9.0}, // 1.778
		{"3:2", 3.0 / 2.0},   // 1.5
		{"4:3", 4.0 / 3.0},   // 1.333
		{"5:4", 5.0 / 4.0},   // 1.25
		{"1:1", 1.0},         // 1.0
		{"4:5", 4.0 / 5.0},   // 0.8
		{"3:4", 3.0 / 4.0},   // 0.75
		{"2:3", 2.0 / 3.0},   // 0.667
		{"9:16", 9.0 / 16.0}, // 0.5625
		{"9:21", 9.0 / 21.0}, // 0.429
	}

	// 找最接近的比例
	closest := "16:9"
	minDiff := float64(100)
	for _, r := range ratios {
		diff := abs(ratio - r.value)
		if diff < minDiff {
			minDiff = diff
			closest = r.name
		}
	}
	return closest
}

// abs 返回浮点数的绝对值
func abs(x float64) float64 {
	if x < 0 {
		return -x
	}
	return x
}

// normalizeResolution 标准化分辨率参数为 Vidu 支持的格式
func normalizeResolution(quality string) string {
	// Vidu 支持的分辨率: 720p, 1080p, 2k, 4k
	switch quality {
	case "720p", "hd":
		return "720p"
	case "1080p", "fhd", "standard":
		return "1080p"
	case "2k", "qhd":
		return "2k"
	case "4k", "uhd", "high":
		return "4k"
	default:
		// 如果是数字分辨率格式，尝试映射
		if quality == "2560x1440" || quality == "1440p" {
			return "2k"
		}
		if quality == "3840x2160" || quality == "2160p" {
			return "4k"
		}
		if quality == "1920x1080" {
			return "1080p"
		}
		if quality == "1280x720" {
			return "720p"
		}
		return "1080p" // 默认值
	}
}
