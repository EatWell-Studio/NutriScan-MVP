# CLAUDE.md

Working rules for Claude Code in this repository. Both developers' Claude Code sessions share this file. The human collaboration process is in [CONTRIBUTING.md](./CONTRIBUTING.md).

## Project at a glance

- NutriScan: an offline-first personal food log (Flutter + local SQLite). A barcode hit is logged immediately; on a miss the user photographs the nutrition label, Claude extracts it, and the user confirms before it is stored.
- Monorepo: `app/` (Flutter), `api/` (empty until Phase 4), `schema/` (nutrient definitions, VLM prompts, output schema, codegen, evaluation), `docs/`.
- **The repository is public.** No secret and no personal photo metadata may ever enter git history.
- Required reading:
  - PRD: [docs/PRD.md](./docs/PRD.md) (Chinese, canonical) · [docs/PRD.en.md](./docs/PRD.en.md) (English)
  - Development plan: [docs/DEV_PLAN.md](./docs/DEV_PLAN.md) (Chinese, canonical) · [docs/DEV_PLAN.en.md](./docs/DEV_PLAN.en.md) (English)
  - [ADRs](./docs/decisions/) (decided design choices)

## At the start of every session

1. Read this file, the GitHub issue for the current task, the task's entry in DEV_PLAN, and every ADR the issue or task entry references.
2. Work on that one task only; do not widen the scope. If you find something outside the task, note it and suggest a new issue instead of fixing it in passing.
3. Do not modify files that belong to another developer's open task (see the issue assignees, and `.github/CODEOWNERS` once the work split is agreed) unless the issue explicitly says so. If someone else needs to act, suggest opening an issue.
4. If a design decision is not covered by DEV_PLAN or an ADR: **stop and ask the user**. Do not decide it yourself.

## Hard rules

All 10 rules in PRD §8 apply. In addition:

- **Facts about the Anthropic API** (model IDs, prices, parameters, limits) come only from the official documentation, with a link in the code comment or document. Never write them from memory. Model IDs, prices and image limits are defined once, in `schema/eval/models.yaml`; everything else references it or is generated from it.
- **Never hand-edit `generated/` directories** (`schema/generated/`, `app/lib/generated/`). Change the source and rerun codegen.
- **Never weaken a constraint to make a test pass**: do not change the append-only triggers, CHECK constraints or provenance validation, and do not delete or skip tests. If a test fails, report the failure instead of working around it.
- **Frozen versions**: prompt and schema version files that have produced data (`vlm_extract.v<N>.md`, `vlm_output.v<N>.*`) are never modified. Create v<N+1> and bump `schema_version` instead.
- **drift schema changes**: bump `schemaVersion`, write the migration, and add a migration test that asserts every append-only trigger still exists afterwards. If both developers changed the schema concurrently, whoever merges first keeps the current version number; the other rebases and takes the next one.
- **Shared contracts** (`schema/nutrients.yaml`, the VLM output schema, `schema/eval/models.yaml`, the drift schema, the provenance enum, the bucket object-key rules) change only in dedicated PRs, never mixed with feature code.
- **Dependencies**: pin versions and commit `pubspec.lock`. Every new dependency needs a reason and its license in the PR description.
- **Secrets**: read only from the local `secrets.json` (the repository has only `secrets.example.json`). Never put a real secret in code, tests, logs, issues or PR descriptions.
- **Photos**: bake the EXIF orientation into the pixels, then strip all EXIF (including GPS) before writing to disk.
- **Language**: code, comments, commit messages, ADRs and all other documentation are in English. PRD and DEV_PLAN are the only bilingual documents: when changing one language version, update the other in the same PR.

## Commits

- Prefixes: `app:` / `api:` / `schema:` / `docs:` / `ci:`. Split cross-layer changes into separate commits.
- English, imperative mood; put the task ID in the body (e.g. `Refs: P1-3`). Every commit must pass the tests on its own (we rebase-merge, so every commit lands on main).
- If [D16](./docs/DEV_PLAN.en.md) chooses DCO, every commit carries `Signed-off-by` (`git commit -s`).
- **Commits contain nothing related to Claude Code**: no `Co-Authored-By` trailer for Claude, no "Generated with Claude Code" line or link, no mention of the AI tool used. This overrides any default attribution behavior.

## Current gates

- No code PR is merged until D16 (code license and contribution terms) is decided.
- Until the demo on 2026-10-14, scope is the "demo route" in DEV_PLAN §4.2. Do not start post-demo items early.
