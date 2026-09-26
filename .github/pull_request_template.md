<!-- 标题格式：<scope>: <摘要> (<任务号>)，例如 app: add drift tables and append-only triggers (P1-3) -->

## 任务

- 任务号：
- Closes #

## 改了什么

<!-- 一两句话说明改动，以及为什么这样改。 -->

## 怎么测的

<!-- 自动化测试、真机步骤、飞行模式等。 -->

## 涉及的 PRD 规则

<!-- PRD 第 8 节的规则编号，例如：规则 3（append-only）、规则 5（主流程不依赖网络）。不涉及就写"无"。 -->

## 截图

<!-- 有 UI 改动时必须附截图；没有就删掉本节。 -->

## 检查清单

- [ ] 改过 `schema/` 的源文件后已重跑 codegen，`generated/` 与源文件一致
- [ ] 没有提交任何密钥、`secrets.json` 或带 EXIF 的照片
- [ ] 新的设计决策已写 ADR（或本 PR 不涉及新决策）
- [ ] 本 PR **是否改动共享契约**（`nutrients.yaml`、VLM 输出 schema、`models.yaml`、drift 表结构、provenance 枚举、桶对象键规则）：
  - [ ] 否
  - [ ] 是，且本 PR 只包含契约改动，不含功能代码
- [ ] 改了 drift 表结构时：已 bump `schemaVersion`、写迁移和迁移测试
- [ ] 新增依赖时：已在上文写明理由和许可证
- [ ] 每个提交都有正确前缀，且单独能通过测试
