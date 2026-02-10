package image

import (
	"context"
	"fmt"

	"github.com/volcengine/volcengine-go-sdk/service/arkruntime"
	modelArkruntime "github.com/volcengine/volcengine-go-sdk/service/arkruntime/model"
	"github.com/volcengine/volcengine-go-sdk/volcengine"
)

type VolcengineImageClient struct {
	ctx       context.Context
	BaseURL   string
	APIKey    string
	Model     string
	apiClient *arkruntime.Client
}

func NewVolcEngineImageClient(baseURL, apiKey, model string) *VolcengineImageClient {
	if baseURL == "" {
		baseURL = "https://ark.cn-beijing.volces.com/api/v3"
	}
	if model == "" {
		model = "doubao-seedream-4-0-250828" // 默认模型
	}

	apiClient := arkruntime.NewClientWithApiKey(
		apiKey,
		arkruntime.WithBaseUrl(baseURL),
	)

	return &VolcengineImageClient{
		ctx:       context.Background(),
		BaseURL:   baseURL,
		APIKey:    apiKey,
		Model:     model,
		apiClient: apiClient,
	}
}

func (c *VolcengineImageClient) GenerateImage(prompt string, opts ...ImageOption) (*ImageResult, error) {
	options := &ImageOptions{
		Size:    "2K",
		Quality: "standard",
	}

	for _, opt := range opts {
		opt(options)
	}

	model := c.Model
	if options.Model != "" {
		model = options.Model
	}

	promptText := prompt
	if options.NegativePrompt != "" {
		promptText += fmt.Sprintf(". 负面提示: %s", options.NegativePrompt)
	}

	// 处理尺寸参数
	size := options.Size
	if size == "" {
		if model == "doubao-seedream-4-5-251128" {
			size = "2K"
		} else {
			size = "1K"
		}
	}

	// 标准化火山引擎支持的尺寸格式
	size = normalizeVolcengineSize(size)

	fmt.Printf("火山引擎图片: 开始生成图片，提示词=%s, 模型=%s, 尺寸=%s\n", promptText, model, size)

	// 构建生成请求
	generateReq := modelArkruntime.GenerateImagesRequest{
		Model:          model,
		Prompt:         promptText,
		Size:           volcengine.String(size),
		ResponseFormat: volcengine.String(modelArkruntime.GenerateImagesResponseFormatURL),
		Watermark:      volcengine.Bool(false), // 默认不添加水印
	}

	// 如果有参考图片，设置图片参数（注意：火山引擎可能不支持参考图片，这里先预留）
	if len(options.ReferenceImages) > 0 {
		fmt.Printf("火山引擎图片: 检测到参考图片 %d 张，当前模型可能不支持参考图片功能\n", len(options.ReferenceImages))
	}

	// 调用 SDK 生成图片
	imagesResponse, err := c.apiClient.GenerateImages(c.ctx, generateReq)
	if err != nil {
		fmt.Printf("火山引擎图片: 生成图片失败: %v\n", err)
		return nil, fmt.Errorf("火山引擎图片生成失败: %w", err)
	}

	if len(imagesResponse.Data) == 0 {
		return nil, fmt.Errorf("火山引擎没有生成任何图片")
	}

	// 获取第一张图片的URL
	imageURL := ""
	if imagesResponse.Data[0].Url != nil {
		imageURL = *imagesResponse.Data[0].Url
	}

	fmt.Printf("火山引擎图片: 生成完成，图片URL=%s\n", imageURL)

	// 火山引擎是同步生成，直接返回完成状态
	return &ImageResult{
		Status:    "completed",
		ImageURL:  imageURL,
		Completed: true,
	}, nil
}

func (c *VolcengineImageClient) GetTaskStatus(taskID string) (*ImageResult, error) {
	return nil, fmt.Errorf("火山引擎图片生成不支持异步任务状态查询（同步生成）")
}

// normalizeVolcengineSize 标准化火山引擎支持的尺寸格式
func normalizeVolcengineSize(size string) string {
	// 火山引擎支持的尺寸格式: 1K, 2K, 4K 等
	switch size {
	case "720p", "hd":
		return "1K"
	case "1080p", "fhd", "standard", "1K":
		return "1K"
	case "2k", "2K", "qhd", "1440p":
		return "2K"
	case "4k", "4K", "uhd", "high", "2160p":
		return "4K"
	default:
		// 如果是分辨率格式，尝试映射
		if size == "1280x720" || size == "1920x1080" {
			return "1K"
		}
		if size == "2560x1440" {
			return "2K"
		}
		if size == "3840x2160" {
			return "4K"
		}
		// 检查是否已经是火山引擎格式
		if size == "1K" || size == "2K" || size == "4K" {
			return size
		}
		return "2K" // 默认值
	}
}
