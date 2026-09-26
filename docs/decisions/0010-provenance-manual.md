# ADR 0010: Add `manual` to provenance

- Status: Accepted
- Date: 2026-09-26
- Decision: D9

## Context

The first draft of the plan suggested recording manual input as `vlm_user` and telling it apart by `model = "manual"`. That has two problems:

- Provenance should state where data really came from, and manually entered data involves no VLM.
- Changing a CHECK constraint in SQLite requires rebuilding the table, and a rebuild conflicts with the append-only triggers on the three data layers. The enum has to be right the first time.

## Decision

- The provenance enum is `off` / `bls` / `usda` / `vlm_user` / `manual`. The CHECK constraint goes into the first version of the schema (C-5).
- For manual input, `nutrient_records.extraction_id` is null and no extraction row is created.
- An additional CHECK: `provenance = 'vlm_user'` if and only if `extraction_id IS NOT NULL`.

## Consequences

- The provenance list in PRD section 3 is updated to match.
- When output is filtered by provenance, `manual` and `vlm_user` both count as our own data for licensing.
