# ADR 0018: The collaborator counts as the second real user

- Status: Accepted
- Date: 2026-09-26
- Decision: D19

## Context

The PRD lists "a second real user appears" as one of three triggers for introducing cloud sync (Phase 3: Supabase EU, accounts, a Dart data access layer). The collaborating developer (`hyhcrh`) also uses the app day to day.

## Decision

The collaborating developer counts as the second real user.

## Consequences

- The Phase 3 trigger is met. When Phase 3 starts is a separate decision; the plan's recommendation is to schedule it after the 2026-10-14 demo and leave the demo scope unchanged (see [DEV_PLAN §7.2](../DEV_PLAN.en.md)).
- The server-side proxy milestone (ADR 0015) is **not** triggered by this: both users are developers of the app, and that milestone applies before handing the app to anyone outside the two developers.
- Each developer's local database and bucket uploads are already separated by UUID primary keys and the `contributor` field (ADR 0012), which Phase 3 can build on.
