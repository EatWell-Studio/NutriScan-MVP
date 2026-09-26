# ADR 0015：服务端代理里程碑

- 状态：已接受
- 日期：2026-09-26
- 对应决策：D17

## 背景

- Claude API 的 `inference_geo` 只有 `global` 和 `us` 两个值，**没有 EU**；工作区的数据存储地理位置目前也只有 `us`。
- EU 境内推理只剩 Google Vertex AI 和 Amazon Bedrock 两条路，两者都要由服务端持有云平台凭证（GCP 服务账号 / AWS IAM），不能放进移动客户端。
- ADR 0014 原本就规定"分发前密钥改由服务端持有"。

所以这两件事合并为同一个里程碑。

## 决策

建一个**无状态**的服务端代理，职责如下：

1. 转发 VLM 调用。首选 **Vertex AI EU 多区域**：Opus 5.5 和 Sonnet 5 在该区域可用，并支持结构化输出，但需要管理员在组织策略里开启。Bedrock EU 跨区域推理为次选：Opus 5.5 / Sonnet 5 在 Bedrock 上不支持结构化输出，要改用别的办法保证输出格式。
2. 为桶上传签发短期预签名 URL，客户端不再持有 B2 key。

它是以下事项的**前置条件**：

- 把 App 交给两位开发者以外的任何人（包括测试分发）；
- PRD 阶段 5（对外开放）；
- PRD 第 6 节所说的"面向真实用户"。

"无状态"是为了守住 PRD"MVP 没有需要维护的服务端状态"的原则：代理只转发和签名，不存业务数据。

## 启动这个里程碑时要先核实

- 届时选定的型号（ADR 0002）是否在 Vertex AI EU 可用，是否支持结构化输出。
- 区域端点的溢价。
- 平台的图片大小限制：Vertex / Bedrock 为每张 5 MB，比直连 API 更严。
- 客户端如何向代理认证，防止代理被滥用。这需要单独写一条 ADR。

## 参考

- [Claude API 数据驻留](https://platform.claude.com/docs/en/manage-claude/data-residency)
- [Vertex AI 上的 Claude](https://platform.claude.com/docs/en/build-with-claude/claude-on-vertex-ai)
- [Amazon Bedrock 上的 Claude](https://platform.claude.com/docs/en/build-with-claude/claude-in-amazon-bedrock)
- [结构化输出（含各平台支持情况）](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)
