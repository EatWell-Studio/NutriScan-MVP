# ADR 0007：MVP 不打包 USDA

- 状态：已接受
- 日期：2026-09-26
- 对应决策：D6

## 决策

MVP 不打包 USDA FoodData Central Foundation Foods。基础食材只用 BLS（阶段 2）。

## 后果

- 少一个许可来源，合规负担更小。`nutrients.yaml` 里仍然保留 USDA nutrient ID 映射列，将来需要时可以直接接入。
- 阶段 2 结束时再评估一次。
