# Contributing

Two developers, a public repository, one monorepo. This file covers the human collaboration process; the rules for Claude Code are in [CLAUDE.md](./CLAUDE.md). If the two conflict, this file wins and CLAUDE.md must be fixed promptly.

> **Current gate**: until the code license and contribution terms (D16 in DEV_PLAN) are decided, no code PR is merged. Only PRs touching `docs/`, `CLAUDE.md`, `CONTRIBUTING.md`, `.gitignore` and non-workflow files under `.github/` may be merged before that.

## 1. Task tracking

- [DEV_PLAN](./docs/DEV_PLAN.en.md) contains the plan only, **never progress**. Progress lives in GitHub Issues / Projects, so the two of us never edit DEV_PLAN concurrently.
- Every task in DEV_PLAN has one issue whose title starts with the task ID (e.g. `P1-3 drift tables and triggers`), assigned to its owner.
- Assign the issue to yourself before you start, so we never work on the same thing.
- Changes to the plan itself (new tasks, dependencies, owners) go in a separate `docs:` PR against DEV_PLAN.

## 2. Branches and PRs

- `main` is protected; every change is merged through a PR.
- One task = one branch = one PR. Branch name: `<task-id>-<short-description>`, all lowercase, e.g. `p1-3-drift-tables`.
- PR title: `<scope>: <summary> (<task-id>)`, e.g. `app: add drift tables and append-only triggers (P1-3)`. The description contains `Closes #<issue>`.
- Fill in the [PR template](./.github/pull_request_template.md).
- Keep PRs small and complete. Anything found outside the task's scope becomes a new issue, not a drive-by change.
- **Changes to shared contracts get their own PR**, never mixed with feature code. Shared contracts are: `schema/nutrients.yaml`, the VLM output schema, `schema/eval/models.yaml`, the drift schema, the provenance enum, and the bucket object-key rules.
- **New design decisions start as an ADR PR** (`docs/decisions/`); code follows only after both of us approve. The ADR format is in [docs/decisions/README.md](./docs/decisions/README.md).
- Merge method: **rebase merge only** (commits split by layer land on main as they are). Squash merges and merge commits are disabled.
- PRD and DEV_PLAN exist in Chinese (canonical) and English. A PR that changes one version must update the other. All other documentation is English only.

### Branch protection for main

Configure in the GitHub repository settings (owner: DEV_PLAN task G-2):

| Setting | Value |
| --- | --- |
| Require a pull request before merging | On |
| Required approvals | 1 (with two people, this means the other person approves every PR) |
| Dismiss stale approvals when new commits are pushed | On |
| Require status checks to pass | On, all CI jobs selected |
| Require branches to be up to date before merging | On |
| Require linear history | On |
| Do not allow bypassing the above settings | On (admins cannot bypass either) |
| Require review from Code Owners | **Off**, see below |
| Repository merge button | "Allow rebase merging" only |
| Always suggest updating pull request branches | On (the "Update branch" button on a PR; choose "Update with rebase") |
| Automatically delete head branches | On |

About CODEOWNERS: [CODEOWNERS](./.github/CODEOWNERS) is used to request reviewers automatically. "Require review from Code Owners" stays off because GitHub does not let authors approve their own PRs: when the PR author is the only owner of a directory (e.g. an owner changing their own `app/` subdirectory), the PR could never be merged. In a two-person team, "at least 1 approval" already guarantees that the other person reviews.

## 3. Commits

- Prefixes: `app:` / `api:` / `schema:` / `docs:` / `ci:`. One commit touches one layer; split cross-layer changes into several commits.
- English, imperative mood, subject line at most 72 characters; the body names the task, e.g. `Refs: P1-3`.
- Every commit passes the tests on its own (rebase merge puts every commit on main).
- If D16 chooses DCO: every commit carries `Signed-off-by` (`git commit -s`).
- CI checks the commit message prefix (and the sign-off, if DCO is chosen).

## 4. Directory ownership

[CODEOWNERS](./.github/CODEOWNERS) is authoritative. The work split is not decided yet (DEV_PLAN §7.2), so for now both members own everything.

- `schema/`, `docs/decisions/`, `CLAUDE.md`, `CONTRIBUTING.md`, `.github/`: always owned by both; every change needs the other person's review.
- `app/` and `api/`: once the split is agreed, per-directory owners are added to CODEOWNERS. Changing a directory owned by the other person then requires either an explicit note in the issue or prior agreement.

## 5. Shared contracts and the drift schema

- Every drift schema change: bump `schemaVersion`, write the migration, add a migration test (including an assertion that the append-only triggers still exist after migrating).
- If both of us changed the schema concurrently, whoever merges first keeps the current version number; the other rebases, takes the next number and regenerates the migration.
- Prompt / schema version files that have produced data are frozen; any change creates a new version.

## 6. Secrets and privacy

The repository is public.

- Local secrets live in each developer's own `secrets.json` (ignored via `.gitignore`); the repository contains only `secrets.example.json`.
- Each developer has their own Anthropic API key and their own write-only B2 key, so each can be revoked independently.
- Secrets are shared only through a password manager and must **never** appear in issues, PRs, commits, logs or chat.
- CI scans for secrets with gitleaks. If a secret ever reaches git history, **revoke it immediately**; rewriting history is not a substitute for revocation.
- Strip EXIF from evaluation photos before committing them, and check that the image shows nothing personal.

## 7. Dependencies

- Pin versions and commit `pubspec.lock` (same for Python lock files).
- State the reason and license of every new dependency in the PR description. Licenses must be compatible with the code license chosen in D16.
