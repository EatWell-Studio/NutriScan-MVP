# 架构决策记录（ADR）

每个已定的设计决策一条，编号递增、不复用。决策变了就新写一条，把旧的状态改为"已被 ADR NNNN 取代"，不直接改写旧 ADR 的决策内容（实测结果、评测结果这类"待补"小节除外）。

新的设计决策先开 ADR 的 PR，两人都同意后再写代码（见 [CONTRIBUTING.md](../../CONTRIBUTING.md)）。

## 索引

| ADR | 决策 | 状态 |
| --- | --- | --- |
| [0001](./0001-object-storage-b2.md) | D3 对象存储用 Backblaze B2 EU | 已接受，待 P0-6 实测 |
| [0002](./0002-vlm-model-selection.md) | D14 VLM 型号选型流程与标准 | 已接受（流程），型号待评测 |
| [0003](./0003-mistral-eval-only.md) | D15 Mistral 只进评测脚本 | 已接受 |
| [0004](./0004-ui-language.md) | D2 界面语言：中文 + 英文 | 已接受 |
| [0005](./0005-nutrient-key-naming.md) | D4 营养素内部主键命名 | 已接受 |
| [0006](./0006-off-hit-rate-threshold.md) | D5 OFF 命中率阈值与样本量 | 已接受 |
| [0007](./0007-no-usda-in-mvp.md) | D6 MVP 不打包 USDA | 已接受 |
| [0008](./0008-odbl-review-before-release.md) | D7 ODbL 评估放到上架前 | 已接受 |
| [0009](./0009-pending-extraction-entries.md) | D8 离线未命中先记账（数据模型） | 已接受 |
| [0010](./0010-provenance-manual.md) | D9 provenance 增加 `manual` | 已接受 |
| [0011](./0011-photo-original-and-derived.md) | D10 原图与派生图都存、去 EXIF | 已接受 |
| [0012](./0012-bucket-object-layout.md) | D11 桶对象布局 | 已接受 |
| [0013](./0013-riverpod-drift.md) | D12 Riverpod + drift | 已接受 |
| [0014](./0014-secrets-and-api-keys.md) | D13 密钥与 API key 管理 | 已接受 |
| [0015](./0015-server-proxy-milestone.md) | D17 服务端代理里程碑 | 已接受 |

待定、定下后补 ADR：D1（包名）、D16（代码许可证与贡献条款）。

## 模板

```markdown
# ADR NNNN：标题

- 状态：提议中 / 已接受 / 已被 ADR NNNN 取代
- 日期：YYYY-MM-DD
- 对应决策：Dn

## 背景
## 决策
## 后果
## 参考
```
