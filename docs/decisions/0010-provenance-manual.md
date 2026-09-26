# ADR 0010：provenance 增加 `manual`

- 状态：已接受
- 日期：2026-09-26
- 对应决策：D9

## 背景

计划初稿建议把手动输入记为 `vlm_user`，再靠 `model = "manual"` 来区分。这样做有两个问题：

- provenance 应该如实反映数据来源，而手动输入的数据里没有 VLM。
- SQLite 修改 CHECK 约束需要重建表；重建表与三层数据的 append-only 触发器冲突。所以枚举必须一次定对。

## 决策

- provenance 枚举为 `off` / `bls` / `usda` / `vlm_user` / `manual`。CHECK 约束在第一版表结构（C-5）里就写进去。
- 手动输入时 `nutrient_records.extraction_id` 为空，不建 extraction 行。
- 额外加一条 CHECK：`provenance = 'vlm_user'` 当且仅当 `extraction_id IS NOT NULL`。

## 后果

- PRD 第 3 节的 provenance 列表同步修改。
- 对外输出按 provenance 过滤时，`manual` 与 `vlm_user` 在许可上同属自有数据。
