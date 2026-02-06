package ai

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

// ViduTaskQueryResponse 任务查询响应
type ViduTaskQueryResponse struct {
	TaskID      string   `json:"task_id"`
	State       string   `json:"state"`
	Model       string   `json:"model"`
	Prompt      string   `json:"prompt"`
	Images      []string `json:"images"`
	Seed        int      `json:"seed"`
	AspectRatio string   `json:"aspect_ratio"`
	Resolution  string   `json:"resolution"`
	Result      struct {
		Images []string `json:"images,omitempty"` // 生成的图片URL列表
	} `json:"result,omitempty"`
	FailReason  string `json:"fail_reason,omitempty"`
	CallbackURL string `json:"callback_url,omitempty"`
	Payload     string `json:"payload,omitempty"`
	Credits     int    `json:"credits"`
	CreatedAt   string `json:"created_at"`
	UpdatedAt   string `json:"updated_at,omitempty"`
}

// ViduErrorResponse Vidu 错误响应
type ViduErrorResponse struct {
	Error struct {
		Message string `json:"message"`
		Type    string `json:"type"`
		Code    string `json:"code"`
	} `json:"error"`
}

// NewViduClient 创建新的 Vidu 客户端
func NewViduClient(baseURL, apiKey, model string) *ViduClient {
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

// GenerateText 实现 AIClient 接口的 GenerateText 方法
// Vidu 主要用于图片/视频生成，文本生成不支持
func (c *ViduClient) GenerateText(prompt string, systemPrompt string, options ...func(*ChatCompletionRequest)) (string, error) {
	return "", fmt.Errorf("Vidu 不支持文本生成")
}

func (c *ViduClient) GenerateImage(prompt string, size string, n int) ([]string, error) {
	return nil, fmt.Errorf("Vidu 不支持同步图片生成，请使用 GenerateAsyncImage 方法")
}

// GenerateImage 生成图片
func (c *ViduClient) GenerateAsyncImage(prompt string, size string, n int) (*CommonImageGenerationResponse, error) {
	fmt.Printf("Vidu: 生成图片, 提示词=%s, 尺寸=%s, 数量=%d\n", prompt, size, n)

	// 将 size 转换为 aspect_ratio 和 resolution
	// aspect_ratio 比例参数，不同模型支持不同的比例：
	// viduq1：默认值16:9，可选值：16:9、9:16、1:1、3:4、4:3
	// viduq2：默认值16:9，可选值如下：16:9、9:16、1:1、3:4、4:3、21:9、2:3、3:2
	// - auto：表示与首张输入图保持相同比例

	aspectRatio := "16:9"
	resolution := "1080p"

	// 解析 size 参数，例如 "1024x1024" -> "1:1"
	if size != "" {
		switch size {
		case "1024x1024", "1:1":
			aspectRatio = "1:1"
		case "1920x1080", "16:9":
			aspectRatio = "16:9"
		case "1080x1920", "9:16":
			aspectRatio = "9:16"
		case "1536x2048", "3:4":
			aspectRatio = "3:4"
		case "2048x1536", "4:3":
			aspectRatio = "4:3"
		case "2560x1080", "21:9":
			aspectRatio = "21:9"
		}

		// 根据尺寸判断分辨率
		switch size {
		case "2048x2048", "2K":
			resolution = "2K"
		case "4096x4096", "4K":
			resolution = "4K"
		}
	}

	req := &ViduImageGenerationRequest{
		Model:       c.Model,
		Prompt:      prompt,
		AspectRatio: aspectRatio,
		Resolution:  resolution,
	}

	imageEndpoint := "/reference2image"
	url := c.BaseURL + imageEndpoint

	jsonData, err := json.Marshal(req)
	if err != nil {
		fmt.Printf("Vidu: 序列化请求失败: %v\n", err)
		return nil, fmt.Errorf("序列化请求失败: %w", err)
	}

	// 打印请求信息
	fmt.Printf("Vidu: 发送请求到: %s\n", url)
	fmt.Printf("Vidu: 模型=%s, 提示词长度=%d, 参考图片数量=%d\n",
		req.Model, len(req.Prompt), len(req.Images))

	requestPreview := string(jsonData)
	if len(jsonData) > 300 {
		requestPreview = string(jsonData[:300]) + "..."
	}
	fmt.Printf("Vidu: 请求体: %s\n", requestPreview)

	httpReq, err := http.NewRequestWithContext(c.ctx, "POST", url, bytes.NewBuffer(jsonData))
	if err != nil {
		fmt.Printf("Vidu: 创建请求失败: %v\n", err)
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}

	httpReq.Header.Set("Content-Type", "application/json")
	httpReq.Header.Set("Authorization", "Token "+c.APIKey)

	fmt.Printf("Vidu: 执行 HTTP 请求...\n")
	resp, err := c.HTTPClient.Do(httpReq)
	if err != nil {
		fmt.Printf("Vidu: HTTP 请求失败: %v\n", err)
		return nil, fmt.Errorf("发送请求失败: %w", err)
	}
	defer resp.Body.Close()

	fmt.Printf("Vidu: 收到响应状态码: %d\n", resp.StatusCode)

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

	var viduResp CommonImageGenerationResponse
	if err := json.Unmarshal(body, &viduResp); err != nil {
		fmt.Printf("Vidu: 解析响应失败: %v\n", err)
		return nil, fmt.Errorf("解析响应失败: %w", err)
	}

	fmt.Printf("Vidu: 成功创建任务, 任务ID=%s, 状态=%s\n", viduResp.TaskID, viduResp.State)

	return &viduResp, nil
}

// QueryTask 查询任务状态
func (c *ViduClient) QueryTask(taskID string) (*ViduTaskQueryResponse, error) {
	endpoint := fmt.Sprintf("/tasks/%s", taskID)
	url := c.BaseURL + endpoint

	fmt.Printf("Vidu: 查询任务: %s\n", taskID)

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
		fmt.Printf("Vidu: 解析响应失败: %v\n", err)
		return nil, fmt.Errorf("解析响应失败: %w", err)
	}

	fmt.Printf("Vidu: 任务状态=%s\n", taskResp.State)

	return &taskResp, nil
}

// WaitForTask 等待任务完成
func (c *ViduClient) WaitForTask(taskID string, maxWaitTime time.Duration) (*ViduTaskQueryResponse, error) {
	fmt.Printf("Vidu: 等待任务 %s 完成 (最大等待时间: %v)...\n", taskID, maxWaitTime)

	startTime := time.Now()
	checkInterval := 5 * time.Second

	for {
		if time.Since(startTime) > maxWaitTime {
			return nil, fmt.Errorf("任务超时,已等待 %v", maxWaitTime)
		}

		taskResp, err := c.QueryTask(taskID)
		if err != nil {
			return nil, err
		}

		// state 处理状态
		// 可选值：
		// created 创建成功
		// queueing 任务排队中
		// processing 任务处理中
		// success 任务成功
		// failed 任务失败
		switch taskResp.State {
		case "success":
			fmt.Printf("Vidu: 任务完成成功\n")
			return taskResp, nil
		case "failed":
			errMsg := "任务失败"
			if taskResp.FailReason != "" {
				errMsg = taskResp.FailReason
			}
			return nil, fmt.Errorf(errMsg)
		case "created", "queueing", "processing":
			fmt.Printf("Vidu: 任务状态=%s, 继续等待...\n", taskResp.State)
			time.Sleep(checkInterval)
		default:
			return nil, fmt.Errorf("未知的任务状态: %s", taskResp.State)
		}
	}
}

// TestConnection 测试连接
func (c *ViduClient) TestConnection() error {
	fmt.Printf("Vidu: 测试连接, 基础URL=%s, 模型=%s\n", c.BaseURL, c.Model)

	resp, err := c.GenerateAsyncImage("一张简单的测试图片", "1024x1024", 1)
	if err != nil {
		fmt.Printf("Vidu: 连接测试失败: %v\n", err)
		return err
	}

	fmt.Printf("Vidu: 连接测试成功, 任务ID=%s\n", resp.TaskID)
	return nil
}
