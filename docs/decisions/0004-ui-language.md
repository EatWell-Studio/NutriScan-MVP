# ADR 0004: UI language: Chinese + English

- Status: Accepted
- Date: 2026-09-26
- Decision: D2

## Decision

- From P1-1 on, the app uses Flutter ARB localization and maintains `app_zh.arb` and `app_en.arb` in parallel.
- The demo on 2026-10-14 uses the English UI.
- All UI text goes through ARB. No UI strings are hardcoded.
- Label recognition first supports German labels (PRD section 6), independent of the UI language.

## Consequences

- Every PR that touches UI text updates both ARB files. A missing translation means the PR is not done.
