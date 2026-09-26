# ADR 0014：密钥与 API key 管理

- 状态：已接受
- 日期：2026-09-26
- 对应决策：D13

## 背景

仓库是公开的；Claude API 是付费 key，泄露会直接产生费用。

## 决策

- **Anthropic**：为 NutriScan 单独建一个工作区，在工作区级别设月度消费上限（Default Workspace 不能设上限）。两位开发者在这个工作区里各用一把 key。
- **B2**：每人一把只写 key（ADR 0001）。
- **本地**：密钥放在各自的 `secrets.json`（`.gitignore`），用 `--dart-define-from-file=secrets.json` 编译期注入。仓库里只放 `secrets.example.json`。
- **共享**：只通过密码管理器共享，不能出现在 issue、PR、提交、日志或聊天记录里。
- **CI**：用 gitleaks 扫描密钥。
- **泄露处理**：立即吊销这把 key 并换新；重写 git 历史不能代替吊销。
- **分发前**：密钥从客户端移除，改由服务端代理持有（ADR 0015）。

## 参考

- [工作区与消费上限](https://platform.claude.com/docs/en/manage-claude/workspaces)
