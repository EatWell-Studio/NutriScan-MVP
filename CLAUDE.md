# CLAUDE.md

本文件是本仓库给 Claude Code 的工作规则，两位开发者的 Claude Code 共用这一份。人类协作流程见 [CONTRIBUTING.md](./CONTRIBUTING.md)。

## 项目速览

- NutriScan：offline-first 的个人饮食记录 App（Flutter + 本地 SQLite），扫码命中即记录，未命中则拍营养成分表，由 Claude 提取、用户确认后入库。
- 单仓库：`app/`（Flutter）、`api/`（阶段 4 前为空）、`schema/`（营养素定义、VLM prompt、输出 schema、codegen、评测）、`docs/`。
- **仓库是公开的。** 任何密钥、个人照片元数据都不能进入 git 历史。
- 必读文档：[PRD](./docs/PRD.md)（做什么、为什么）、[DEV_PLAN](./docs/DEV_PLAN.md)（任务、依赖、负责人）、[ADR](./docs/decisions/)（已定的设计决策）。

## 每次会话开始时

1. 读本文件、当前任务的 GitHub Issue、DEV_PLAN 里对应的任务条目，以及 issue 或任务条目引用的 ADR。
2. 只做这一个任务，不扩大范围。发现任务范围之外的问题时，记下来建议开新 issue，不要顺手修改。
3. 不修改另一条线负责的目录（归属见 `.github/CODEOWNERS` 和 DEV_PLAN 第 4 节），除非 issue 里明确写了。需要对方配合时，建议开 issue 说明。
4. 遇到 DEV_PLAN 或 ADR 没覆盖的设计决策：**停下来问用户**，不要自己定。

## 硬性规则

PRD 第 8 节的 10 条规则全部适用。在此基础上：

- **Anthropic API 相关事实**（型号 ID、价格、参数、限制）只以官方文档为准，并在代码注释或文档里附上链接，不凭记忆写。型号 ID、价格、图片上限只在 `schema/eval/models.yaml` 定义一次，其他地方引用或由 codegen 生成。
- **禁止手改 `generated/` 目录**（`schema/generated/`、`app/lib/generated/`）。改源文件后重跑 codegen。
- **禁止为了让测试通过去削弱约束**：不改 append-only 触发器、CHECK 约束、provenance 校验，不删测试，不跳过测试。测试失败时报告失败，而不是绕过。
- **版本冻结**：已经产生过数据的 prompt 和 schema 版本文件（`vlm_extract.v<N>.md`、`vlm_output.v<N>.*`）不再修改。要改就新建 v<N+1>，同步 bump `schema_version`。
- **drift 表结构变更**：bump `schemaVersion`，写迁移，加迁移测试（包括断言所有 append-only 触发器在迁移后仍然存在）。如果两人同时改了表结构，先合并的一方持有当前版本号，后合并的一方 rebase 后顺延版本号。
- **共享契约**（`schema/nutrients.yaml`、模型输出 schema、`schema/eval/models.yaml`、drift 表结构、provenance 枚举、桶对象键规则）的改动单独成 PR，不和功能代码混在一起。
- **依赖**：锁定版本，`pubspec.lock` 入库。新增依赖要在 PR 描述里写明理由和许可证。
- **密钥**：只从本地 `secrets.json` 读取（仓库里只有 `secrets.example.json`）。不在代码、测试、日志、issue、PR 描述里写入任何真实密钥。
- **照片**：写盘前去掉 EXIF（含 GPS），先按 EXIF 方向把旋转烘焙进像素再去掉 EXIF。

## 提交

- 前缀：`app:` / `api:` / `schema:` / `docs:` / `ci:`。跨层改动拆成多个提交。
- 英文、祈使句，正文写任务号（如 `Refs: P1-3`）。每个提交单独都能通过测试（合并方式是 rebase merge，每个提交都会进入 main）。
- 若 [D16](./docs/DEV_PLAN.md) 选择了 DCO，每个提交带 `Signed-off-by`（`git commit -s`）。

## 当前阶段的门槛

- D16（代码许可证与贡献条款）拍板之前，不合并任何代码 PR。
- 演示日 2026-10-14 之前的范围以 DEV_PLAN 第 4 节"演示路线"为准，推迟项不要提前做。
