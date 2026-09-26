# ADR 0002：VLM 型号选型流程与标准

- 状态：已接受（流程与标准）；型号待 P05-5 评测后补入"结果"一节
- 日期：2026-09-26
- 对应决策：D14

## 背景

识图改用 Claude（PRD 第 4 节）。型号更新很快，而评测集不变。选型要以评测数据为准，不能凭印象。

## 决策

- **候选**：Claude Opus 5.5、Claude Sonnet 5、Claude Haiku 4.5。
- **参照**：Claude Fable 5.1 在评测集上跑一次，只作为准确率上限参照，**不作为候选**。
- **Mistral** 只在评测脚本里跑，见 ADR 0003。
- **选型标准，按优先级**：
  1. 静默错误率：与真值不符、而且没被任何校验规则或低置信度标出来的字段所占比例
  2. P90 延迟 ≤ 25 s
  3. 成本。在我们的用量下只有个位数美元，只在前两项打平时才起决定作用
- **评测矩阵**：Opus 5.5 与 Sonnet 5 各跑 `low`、`medium` 两档 effort；Haiku 4.5 不支持 effort 参数，只跑一档；Fable 5.1 用默认 effort。每次调用记录输入 / 输出 token 数，成本由 `schema/eval/models.yaml` 的价格算出。
- **结果出来之前**，App 暂用官方推荐的默认起点 Opus 5.5，effort 用 `low`，写在 `models.yaml` 的 `app_default` 里。
- 型号 ID、价格、图片上限只在 `models.yaml` 定义，本 ADR 不写具体数字。

## 选型时要一并考虑的已知事实（2026-09-26 核实）

- Opus 5.5 的思考模式始终开启、不能关闭，默认 effort 为 `medium`。
- Haiku 4.5 不支持 effort 参数；图片属于标准分辨率档，其余候选属于高分辨率档。
- Haiku 4.5 在 Vertex AI / Bedrock 上的退役日期最早在 2026 年 10 月中旬。选它的话，将来的 EU 路线（ADR 0015）可能用不了。
- 在 EU 路线上：Vertex AI 的 EU 多区域提供 Opus 5.5 和 Sonnet 5，并支持结构化输出；Bedrock 上的 Opus 5.5 / Sonnet 5 不支持结构化输出。

## 结果（P05-5 填写）

| 配置 | ① Atwater 失败率 | ② 逐字段准确率 | ③ 静默错误率 | P50 | P90 | 单次成本 |
| --- | --- | --- | --- | --- | --- | --- |
| | | | | | | |

- 选定型号与 effort：
- 置信度阈值、校验阈值：
- "全部通过时一键确认"是否启用（依据 ③）：

## 参考

- [模型概览](https://platform.claude.com/docs/en/models/overview)
- [effort](https://platform.claude.com/docs/en/build-with-claude/effort)
- [vision](https://platform.claude.com/docs/en/build-with-claude/vision)
- [结构化输出](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)
- [Vertex AI 上的 Claude](https://platform.claude.com/docs/en/build-with-claude/claude-on-vertex-ai)
