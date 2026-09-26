# ADR 0007: No USDA data bundled in the MVP

- Status: Accepted
- Date: 2026-09-26
- Decision: D6

## Decision

The MVP does not bundle USDA FoodData Central Foundation Foods. BLS is the only source for basic foods (phase 2).

## Consequences

- One fewer license source means less compliance work. `nutrients.yaml` still keeps the USDA nutrient ID mapping column, so USDA data can be added later.
- Re-evaluate at the end of phase 2.
