# ADR 0005：营养素内部主键命名

- 状态：已接受
- 日期：2026-09-26
- 对应决策：D4

## 决策

- 营养素内部主键用带单位后缀的 snake_case（`energy_kcal`、`energy_kj`、`fat_g`、`saturated_fat_g`、`salt_g`、`sodium_mg` …），与 PRD 编码规范一致。
- EuroFIR 代码、OFF 字段名、USDA nutrient ID 都是 `schema/nutrients.yaml` 里的映射列。
- 演示前先填 OFF 映射；EuroFIR / USDA 映射在 P0-3（BLS 笔记）之后补。

## 后果

- "以 BLS 为主还是以 OFF 为主"不再是二选一。
- 主键一旦产生过数据就不再改名；要改，按共享契约流程新增字段并迁移。
