# ADR 0023: CI architecture and commit conventions

- Status: Accepted
- Date: 2026-09-26
- Decision: D22

## Decision

**Toolchain**

Baseline: the latest stable releases on 2026-09-26, pinned to exact versions.

| Tool | Version | Source |
| --- | --- | --- |
| Flutter | 3.47.5 (stable, released 2026-09-18) | [Flutter release index](https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json) |
| Dart | 3.13.4 (bundled with Flutter 3.47.5) | same as above |
| Python | 3.14.7 (released 2026-08-05) | [python.org downloads](https://www.python.org/downloads/) |
| gitleaks | v8.30.1 | [gitleaks releases](https://github.com/gitleaks/gitleaks/releases) |

- P1-2 pins these versions in one place each (the workflow, `pubspec.yaml` SDK constraints, `requires-python` in `pyproject.toml`). This ADR records the baseline; the pinned files are the source of truth afterwards.
- Upgrades happen deliberately in dedicated `ci:` / `chore:` PRs, never as a side effect of feature work.
- Dependencies must fit the baseline, e.g. `mobile_scanner` 7.x requires Flutter ≥ 3.29 and Dart ^3.7.

**Workflow**

- One workflow for the MVP; path filters per layer come after the demo.
- Jobs: `flutter analyze` + `flutter test`; `ruff` + `pytest`; codegen diff (`git diff --exit-code` after regenerating); secret scan; commit message check. Jobs for parts that do not exist yet are added when those parts land.
- **Secret scan**: the gitleaks command-line tool, pinned version, run directly in CI. No gitleaks-action and no license key.
- Tests that need API keys (`live`) do not run in CI.

**Commit message check** (every commit in a PR; format in CONTRIBUTING §3)

- Subject: `^(app|api|schema|docs|ci|chore): ` followed by the summary; at most 72 characters in total.
- Body: must contain a `Refs:` line with one or more DEV_PLAN task IDs.
- No sign-off check (ADR 0021).

**Branch protection**

- Once P1-2 is merged, every CI job becomes a required status check on `main` (task G-2).

## Consequences

- `chore:` is added to the prefix set for repository-level housekeeping (e.g. `.gitignore`) that fits no layer.
- Commits merged before CI existed are not checked retroactively.
