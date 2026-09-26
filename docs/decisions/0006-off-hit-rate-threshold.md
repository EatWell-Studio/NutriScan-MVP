# ADR 0006: OFF hit-rate thresholds and sample size

- Status: Accepted
- Date: 2026-09-26
- Decision: D5

## Decision

- The thresholds stay the same: F1 takes priority at a hit rate ≥ 60%, F2 takes priority below 30%.
- The sample grows to 30+ barcodes taken from shopping receipts (P0-1). It covers Rewe, Lidl, Kaufland and Alnatura own brands, plus Asian products.
- A "hit" means all seven core `nutriments` fields are present. Entries with only a name and photos, or with empty `nutriments`, count as misses.

## Consequences

- With two tracks running in parallel, the hit rate no longer affects the pre-demo order. It mainly sets post-demo priorities and helps pick the demo products: one found in OFF and one not in OFF.
- Results go into `docs/notes/off-hit-rate.md`.
