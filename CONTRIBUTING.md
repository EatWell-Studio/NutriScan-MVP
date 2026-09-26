# 协作规则

两人协作，公开仓库，单仓库（monorepo）。本文件约定人类协作流程；Claude Code 的工作规则见 [CLAUDE.md](./CLAUDE.md)。两者冲突时以本文件为准，并尽快修正 CLAUDE.md。

> **当前门槛**：代码许可证与贡献条款（DEV_PLAN 的 D16）拍板之前，不合并任何代码 PR。只有 `docs/`、`CLAUDE.md`、`CONTRIBUTING.md` 和 `.github/` 下非 workflow 文件的 PR 可以先合并。

## 1. 任务跟踪

- [DEV_PLAN](./docs/DEV_PLAN.md) 只放计划本身，**不记录进度**。进度只在 GitHub Issues / Projects 里跟踪，避免两人同时改 DEV_PLAN 产生冲突。
- DEV_PLAN 里的每个任务对应一个 Issue，标题带任务号（如 `P1-3 drift 表定义与触发器`），指派给负责人。
- 开工前先把 issue 指派给自己，防止两人撞车。
- 计划本身需要调整时（加任务、改依赖、改负责人），单独开 `docs:` PR 改 DEV_PLAN。

## 2. 分支与 PR

- `main` 受保护，所有改动经 PR 合并。
- 一个任务 = 一个分支 = 一个 PR。分支名 `<任务号>-<短描述>`，全小写，如 `p1-3-drift-tables`。
- PR 标题：`<scope>: <摘要> (<任务号>)`，如 `app: add drift tables and append-only triggers (P1-3)`。描述里写 `Closes #<issue>`。
- 按 [PR 模板](./.github/pull_request_template.md) 填写。
- PR 保持小而完整。超出任务范围的发现开新 issue，不顺手改。
- **共享契约的改动单独开 PR**，不和功能代码混在一起。共享契约包括：`schema/nutrients.yaml`、VLM 输出 schema、`schema/eval/models.yaml`、drift 表结构、provenance 枚举、桶对象键规则。
- **新的设计决策先开 ADR 的 PR**（`docs/decisions/`），两人都同意后再写代码。ADR 格式见 [docs/decisions/README.md](./docs/decisions/README.md)。
- 合并方式只用 **rebase merge**（按层拆开的提交原样进入 main），禁用 squash merge 和 merge commit。

### main 的分支保护设置

在 GitHub 仓库设置里配置（负责人见 DEV_PLAN 任务 G-2）：

| 设置 | 值 |
| --- | --- |
| Require a pull request before merging | 开 |
| Required approvals | 1（只有两个人，等于每个 PR 都必须由另一人批准） |
| Dismiss stale approvals when new commits are pushed | 开 |
| Require status checks to pass | 开，勾选 CI 的全部 job |
| Require branches to be up to date before merging | 开 |
| Require linear history | 开 |
| Do not allow bypassing the above settings | 开（管理员也不能绕过） |
| Require review from Code Owners | **关**，原因见下 |
| 仓库 Merge button | 只允许 "Allow rebase merging" |

关于 CODEOWNERS：[CODEOWNERS](./.github/CODEOWNERS) 用来自动请求评审人。不开启 "Require review from Code Owners"，因为 GitHub 不允许作者批准自己的 PR：当一个目录的唯一 owner 就是 PR 作者时（例如负责人改自己线上的 `app/` 子目录），这个 PR 永远无法合并。"至少 1 个批准"在两人团队里已经保证了另一人必须 review。

## 3. 提交

- 前缀：`app:` / `api:` / `schema:` / `docs:` / `ci:`。一个提交只改一层，跨层改动拆成多个提交。
- 英文、祈使句、首行不超过 72 字符；正文写任务号，如 `Refs: P1-3`。
- 每个提交都能单独通过测试（rebase merge 会把每个提交放进 main）。
- 若 D16 选择了 DCO：每个提交带 `Signed-off-by`（`git commit -s`）。
- CI 会检查提交信息前缀（D16 选了 DCO 的话也会检查 sign-off）。

## 4. 目录归属

以 [CODEOWNERS](./.github/CODEOWNERS) 为准，分工的来由见 DEV_PLAN 第 4 节。

- `schema/`、`docs/decisions/`、`CLAUDE.md`、`CONTRIBUTING.md`、`.github/`：两人共同负责，任何改动都要另一人 review。
- `app/` 与 `api/`：按分工指定 owner。改动另一条线负责的目录，需要 issue 里明确写明，或事先和对方确认。

## 5. 共享契约与 drift 表结构

- drift 表结构每次变更：bump `schemaVersion`、写迁移、加迁移测试（含"append-only 触发器在迁移后仍然存在"的断言）。
- 两人同时改了表结构时，先合并的一方持有当前版本号；后合并的一方 rebase 后顺延版本号并重新生成迁移。
- 已经产生过数据的 prompt / schema 版本文件冻结，改动一律新建版本。

## 6. 密钥与隐私

仓库是公开的。

- 本地密钥放在各自的 `secrets.json`（由 P1-1 加入 `.gitignore`），仓库里只有 `secrets.example.json`。
- 每位开发者各有一把 Anthropic API key 和一把 B2 只写 key，便于单独吊销。
- 密钥只通过密码管理器共享，**不能**出现在 issue、PR、提交、日志或聊天记录里。
- CI 用 gitleaks 扫描密钥。一旦有密钥进入 git 历史，**立即吊销**；重写历史不能代替吊销。
- 评测集照片提交前去掉 EXIF，并自查画面里有没有个人信息。

## 7. 依赖

- 版本锁定，`pubspec.lock` 入库（Python 侧同理锁定）。
- 新增依赖在 PR 描述里写明理由和许可证。许可证须与 D16 选定的代码许可证兼容。
