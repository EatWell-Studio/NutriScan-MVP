# ADR 0009: Log offline misses first

- Status: Accepted (data model). The UI is deferred until after the demo.
- Date: 2026-09-26
- Decision: D8

## Context

The PRD says photos are stored locally while offline and extracted once back online. It does not say how to log what the user eats in the meantime.

## Decision

- The data model supports this now. `log_entries.nutrient_record_id` may be null, which marks a pending extraction, and the matching `extractions.status` is `'pending'`.
- The daily summary leaves pending extraction entries out of the totals and shows how many there are.
- The UI for listing pending extractions and confirming them one by one once online (P1-15) comes after the demo. Before the demo, an offline miss still writes the photos and the pending entry, and the UI only says "Saved, will be processed when online".

## Consequences

- The schema is complete up front, so adding the UI after the demo needs no migration.
