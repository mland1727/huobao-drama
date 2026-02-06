package ai

import (
	"context"
	"fmt"

	"github.com/volcengine/volcengine-go-sdk/service/arkruntime"
	"github.com/volcengine/volcengine-go-sdk/service/arkruntime/model"
	"github.com/volcengine/volcengine-go-sdk/volcengine"
)

type VolcengineClient struct {
	ctx       context.Context
	model     string
	apiClient *arkruntime.Client
}

// NewVolcengineClient 创建火山引擎 Arkruntime 客户端
func NewVolcengineClient(baseURL, apiKey, model string) *VolcengineClient {
	if baseURL == "" {
		baseURL = "https://ark.cn-beijing.volces.com/api/v3"
	}
	apiClient := arkruntime.NewClientWithApiKey(
		// 从环境变量中获取您的 API Key。此为默认方式，您可根据需要进行修改
		apiKey,
		// 此为默认路径，您可根据业务所在地域进行配置
		arkruntime.WithBaseUrl(baseURL),
	)

	return &VolcengineClient{
		ctx:       context.Background(),
		model:     model,
		apiClient: apiClient,
	}
}

// GenerateText 使用火山引擎生成文本
// prompt: 用户输入的提示语
// systemPrompt: 系统提示语
// options: 可选参数，如最大 token 数等
func (c *VolcengineClient) GenerateText(prompt string, systemPrompt string, options ...func(*ChatCompletionRequest)) (string, error) {
	messages := []*model.ChatCompletionMessage{}
	// 如果有系统提示语，先添加系统消息
	if systemPrompt != "" {
		messages = append(messages, &model.ChatCompletionMessage{
			Role: model.ChatMessageRoleSystem,
			Content: &model.ChatCompletionMessageContent{
				StringValue: volcengine.String(systemPrompt),
			},
		})
	}
	// 添加用户输入的提示语
	messages = append(messages, &model.ChatCompletionMessage{
		Role: model.ChatMessageRoleUser,
		Content: &model.ChatCompletionMessageContent{
			StringValue: volcengine.String(prompt),
		},
	})
	// 调用 ChatCompletion 接口
	resp, err := c.ChatCompletion(messages, options...)
	if err != nil {
		return "", err
	}

	if len(resp.Choices) == 0 {
		return "", fmt.Errorf("no response from API")
	}

	return *resp.Choices[0].Message.Content.StringValue, nil
}

func (c *VolcengineClient) GenerateImage(prompt string, size string, n int) ([]string, error) {
	return nil, nil
}

func (c *VolcengineClient) GenerateAsyncImage(prompt string, size string, n int) (*CommonImageGenerationResponse, error) {
	return nil, fmt.Errorf("GenerateAsyncImage not implemented for Volcengine client")
}

// TestConnection 测试与火山引擎的连接是否成功
func (c *VolcengineClient) TestConnection() error {
	messages := []*model.ChatCompletionMessage{
		{
			Role: model.ChatMessageRoleUser,
			Content: &model.ChatCompletionMessageContent{
				StringValue: volcengine.String("你好"),
			},
		},
	}

	_, err := c.ChatCompletion(messages, WithMaxTokens(50))
	if err != nil {
		fmt.Printf("火山引擎: TestConnection 失败: %v\n", err)
	} else {
		fmt.Printf("火山引擎: TestConnection 成功\n")
	}
	return err
}

// ChatCompletion 调用火山引擎的 CreateChatCompletion 接口
func (c *VolcengineClient) ChatCompletion(messages []*model.ChatCompletionMessage, options ...func(*ChatCompletionRequest)) (*model.ChatCompletionResponse, error) {
	// medium := model.ReasoningEffortMedium
	req := model.CreateChatCompletionRequest{
		// 指定您创建的方舟推理接入点 ID，此处已帮您修改为您的推理接入点 ID
		Model:    c.model,
		Messages: messages,
		// ReasoningEffort: &medium,
		Thinking: &model.Thinking{
			Type: model.ThinkingTypeDisabled, // 禁用深度思考
			// Type: model.ThinkingTypeEnabled, // 启用深度思考
		},
	}
	resp, err := c.apiClient.CreateChatCompletion(c.ctx, req)
	if err != nil {
		fmt.Printf("调用火山CreateChatCompletion错误: %v\n", err)
		return nil, err
	}
	return &resp, nil
}
