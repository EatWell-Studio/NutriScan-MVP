# ADR 0003: Mistral only in the evaluation script

- Status: Accepted
- Date: 2026-09-26
- Decision: D15

## Context

Mistral was originally the fallback for EU data residency. The EU route now has two other options, Vertex AI and Bedrock (ADR 0015), and the pre-demo scope is already large.

## Decision

- Keep Mistral, but only in `schema/eval/run.py`, as an evaluation baseline. Its adapter is scheduled after the demo.
- No Mistral client in the app before the demo.
- EU route priority: ① Vertex AI EU multi-region → ② Bedrock EU cross-region inference (limited by structured-output support) → ③ Mistral.

## Consequences

- The shared prompt and output schema must stay usable with Mistral. The evaluation script keeps checking this.
- Enabling Mistral in the app later needs its own task and a new ADR.
