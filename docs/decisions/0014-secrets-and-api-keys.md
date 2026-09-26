# ADR 0014: Secrets and API key management

- Status: Accepted
- Date: 2026-09-26
- Decision: D13

## Context

The repository is public, and the Claude API key is a paid key, so a leak costs money directly.

## Decision

- **Anthropic** (applies once API access is enabled, see ADR 0020): create a dedicated workspace for NutriScan and set a monthly spend limit on it (the Default Workspace cannot have one). Each developer uses their own key in this workspace.
- **B2**: one write-only key per developer (ADR 0001).
- **Local**: secrets live in each developer's own `secrets.json` (in `.gitignore`) and are injected at build time with `--dart-define-from-file=secrets.json`. The repository contains only `secrets.example.json`.
- **Sharing**: share secrets only through a password manager, never in issues, PRs, commits, logs or chat.
- **CI**: gitleaks scans for secrets.
- **If a key leaks**: revoke and replace it immediately. Rewriting git history is not a substitute for revocation.
- **Before distribution**: remove secrets from the client; the server-side proxy holds them (ADR 0015).

## References

- [Workspaces and spend limits](https://platform.claude.com/docs/en/manage-claude/workspaces)
