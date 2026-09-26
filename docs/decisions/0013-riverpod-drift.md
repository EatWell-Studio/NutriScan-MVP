# ADR 0013: Riverpod + drift

- Status: Accepted
- Date: 2026-09-26
- Decision: D12

## Decision

- State management uses Riverpod.
- The local database uses drift (SQLite). It is type-safe, has testable migrations, supports in-memory databases for unit tests, and allows native SQL triggers.
- The UI never touches drift directly and goes only through the repository layer (PRD coding conventions).

## Consequences

- Migration tests rely on drift schema snapshots (`drift_dev schema dump`). Every schema change commits a new snapshot (CONTRIBUTING section 5).
