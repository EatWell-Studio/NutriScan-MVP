# ADR 0021: MIT license for the MVP phase

- Status: Accepted
- Date: 2026-09-26
- Decision: D16

## Context

The initial commit already contained an MIT `LICENSE` naming "EatWell Studio". Code ownership was settled in ADR 0017: the code is jointly owned by the two members of EatWell Studio. The options compared are in [DEV_PLAN §7.3](../DEV_PLAN.en.md).

## Decision

- The code is licensed under **MIT** during the MVP phase, for maximum freedom in coding.
- No DCO sign-off and no CLA are required during the MVP phase, so CI does not check for sign-offs.
- External code contributions are not accepted during the MVP phase; only the two members contribute code.
- The `LICENSE` copyright line names the two members: `Copyright (c) 2026 Hannes Gao and hyhcrh (members of EatWell Studio)`.

## Consequences

- The gate "no code PR is merged before D16" is lifted.
- Every version published under MIT stays available under MIT permanently. A later license change applies only to code written after the change, and needs both members' agreement (ADR 0017).
- New dependencies must be compatible with MIT; a copyleft (GPL family) dependency needs an explicit decision first (CONTRIBUTING §7).
- Data licenses are independent of the code license: OFF data stays ODbL, BLS stays CC BY 4.0 (ADR 0008).
- Revisit this ADR before accepting contributions from outside the two members (contribution terms), and before commercialization or Phase 5.
