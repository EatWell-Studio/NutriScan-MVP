# ADR 0005: Internal nutrient key naming

- Status: Accepted
- Date: 2026-09-26
- Decision: D4

## Decision

- Internal nutrient keys are snake_case with a unit suffix (`energy_kcal`, `energy_kj`, `fat_g`, `saturated_fat_g`, `salt_g`, `sodium_mg` …), matching the PRD coding conventions.
- EuroFIR codes, OFF field names and USDA nutrient IDs are mapping columns in `schema/nutrients.yaml`.
- Before the demo, only the OFF mapping is filled in. The EuroFIR and USDA mappings are added after P0-3 (BLS notes).

## Consequences

- We no longer have to choose between BLS and OFF as the primary standard.
- Once a key has data, it is never renamed. Changes go through the shared contract process: add a new field and migrate.
