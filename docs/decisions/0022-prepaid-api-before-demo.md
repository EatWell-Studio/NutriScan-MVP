# ADR 0022: Prepaid API access before the demo

- Status: Accepted
- Date: 2026-09-26
- Decision: D21 (resolves the open question in [ADR 0020](./0020-claude-access.md))

## Context

Claude subscriptions do not include API usage, but in-app extraction (P1-11, demo route step 3) and the evaluation script (P05-4) both call the Messages API. ADR 0020 listed three options.

## Decision

- **Option A**: prepay API usage now through **Hannes's Startup account**, used only for evaluation, debugging and the demo.
- In that account, create a dedicated NutriScan workspace with a monthly spend limit; each developer gets their own key in it, distributed through the password manager (ADR 0014, task G-3).
- Development tooling is unchanged from ADR 0020, with one update: mica's trial pass expires on 2026-10-02, after which mica continues on a Claude Pro subscription.

## Consequences

- P05-4 and P1-11 are unblocked, and model selection (ADR 0002) happens before the demo as planned.
- Estimate evaluation runs from the `models.yaml` prices before running them; the workspace spend limit caps the total.
- The long-term API setup after the demo is part of post-demo planning (DEV_PLAN §7.2).
