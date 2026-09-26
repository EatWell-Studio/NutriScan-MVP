# ADR 0013：Riverpod + drift

- 状态：已接受
- 日期：2026-09-26
- 对应决策：D12

## 决策

- 状态管理用 Riverpod。
- 本地数据库用 drift（SQLite）：类型安全、迁移可测、支持内存库单测、可以写原生 SQL 触发器。
- UI 不直接访问 drift，只经 repository 层（PRD 编码规范）。

## 后果

- 迁移测试依赖 drift 的 schema 快照（`drift_dev schema dump`），每次表结构变更都要提交新快照（CONTRIBUTING 第 5 节）。
