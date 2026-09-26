# ADR 0003：Mistral 只进评测脚本

- 状态：已接受
- 日期：2026-09-26
- 对应决策：D15

## 背景

Mistral 原本是 EU 数据驻留的退路。现在 EU 路线已经有 Vertex AI 和 Bedrock 两条（ADR 0015），而演示前的工作量已经超出容量。

## 决策

- 保留 Mistral，但只放进 `schema/eval/run.py`，作为评测对照。它的适配器排在演示之后。
- 演示前 App 里不实现 Mistral client。
- EU 路线的顺位：① Vertex AI EU 多区域 → ② Bedrock EU 跨区域推理（受结构化输出限制）→ ③ Mistral。

## 后果

- 共享的 prompt 与输出 schema 需要能适配 Mistral，这一点由评测脚本持续验证。
- 真要启用 Mistral 时，App 端的 client 另开任务，并写新的 ADR。
