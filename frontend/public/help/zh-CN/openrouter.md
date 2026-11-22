**OpenRouter** 是一项在线服务。一个账号和一个 API 密钥即可访问众多 AI 模型。TwiCC 可以在少数几个地方将其作为可选引擎使用。TwiCC 的其他功能从不需要它。

## TwiCC 在哪里使用它

| 位置 | OpenRouter 的作用 |
|---|---|
| **设置 → 文字转语音** | 使用 **OpenRouter 配置** 朗读消息。它还会在朗读前调整文本。 |
| **设置 → 摘要** | 为消息和选中内容撰写摘要。 |
| **设置 → 标题** | 为会话建议标题。重命名对话框也可以用它尝试生成一个标题。 |

对于文本调整、摘要和标题，TwiCC 使用一个快速文本模型：目前是由 Cerebras 提供的 Qwen3.8 27B。

对于语音，你可以在 **设置 → 文字转语音** 中选择语音模型和音色。TwiCC 会在需要时从 OpenRouter 加载模型和音色列表。参见 [文字转语音](help/text-to-speech)。

## 启用它

1. 在 [openrouter.ai](https://openrouter.ai) 上创建账号并充值积分。
2. 在 [密钥页面](https://openrouter.ai/settings/keys) 创建 API 密钥。
3. 将 `TWICC_OPENROUTER_API_KEY=your-key` 这一行添加到 TwiCC 数据目录中的 `.env` 文件（默认为 `~/.twicc/.env`）。

4. 重启 TwiCC。每次更改密钥后都需要再次重启。

密钥保存在服务器上。TwiCC 从不会将其发送到浏览器。

没有密钥时，OpenRouter 选项处于禁用状态。TwiCC 会保留你的选择，并在设置密钥后重新应用。

## 隐私与费用

- TwiCC 会将文本发送到 OpenRouter：语音和摘要发送消息内容，标题发送用户消息。
- 费用从你的 OpenRouter 账户扣除。设置中显示的价格是 OpenRouter 的标价。实际费用可能有所不同。
- OpenRouter 有自己的条款和数据政策。使用前请先阅读。

## 当 OpenRouter 失败时

对于文本调整、摘要和标题，已启用的智能体会接手：先是 Claude，然后是 Codex。如果没有智能体可以运行，该功能会显示错误，或者按原文朗读。
使用 OpenRouter 的语音配置没有后备方案。请在 **设置 → 文字转语音** 中测试它以查看错误。
