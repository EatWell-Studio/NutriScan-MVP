# ADR 0015: Server-side proxy milestone

- Status: Accepted
- Date: 2026-09-26
- Decision: D17

## Context

- The Claude API's `inference_geo` accepts only `global` and `us`; **there is no EU option**. Workspace data storage is currently `us` only as well.
- That leaves Google Vertex AI and Amazon Bedrock as the only routes for inference in the EU. Both require the server to hold cloud credentials (a GCP service account or AWS IAM), which cannot go into a mobile client.
- ADR 0014 already requires that secrets move to the server before distribution.

The two concerns are therefore merged into one milestone.

## Decision

Build a **stateless** server-side proxy with two jobs:

1. Forward VLM calls. The preferred route is the **Vertex AI EU multi-region**, where Opus 5.5 and Sonnet 5 are available with structured outputs; an admin must enable structured outputs in the organization policy. The second choice is Bedrock EU cross-region inference, where Opus 5.5 and Sonnet 5 do not support structured outputs, so the output format would need another safeguard.
2. Issue short-lived presigned URLs for bucket uploads, so clients no longer hold a B2 key.

This milestone is a **prerequisite** for:

- giving the app to anyone other than the two developers, including test distribution;
- PRD phase 5 (public release);
- serving "real users" as described in PRD section 6.

The proxy is stateless to keep the PRD principle that "the MVP has no server-side state to maintain". It only forwards and signs; it stores no business data.

## Verify before starting this milestone

- Whether the model selected at that point (ADR 0002) is available in the Vertex AI EU multi-region with structured outputs.
- The price premium for regional endpoints.
- Platform image size limits: 5 MB per image on Vertex and Bedrock, stricter than the direct API.
- How clients authenticate to the proxy so it cannot be abused. This needs its own ADR.

## References

- [Claude API data residency](https://platform.claude.com/docs/en/manage-claude/data-residency)
- [Claude on Vertex AI](https://platform.claude.com/docs/en/build-with-claude/claude-on-vertex-ai)
- [Claude in Amazon Bedrock](https://platform.claude.com/docs/en/build-with-claude/claude-in-amazon-bedrock)
- [Structured outputs (including per-platform support)](https://platform.claude.com/docs/en/build-with-claude/structured-outputs)
