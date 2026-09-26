# ADR 0016: App name and package name

- Status: Accepted
- Date: 2026-09-26
- Decision: D1

## Decision

- App name: `NutriScan`.
- Package name / application ID: `de.belvast.nutriscan`, the reverse of the domain `belvast.de`, which the team owns. It is used as the Android `applicationId` and the iOS bundle identifier.
- Dart package name in `pubspec.yaml`: `nutriscan`.

## Consequences

- P1-1 creates the Flutter project with this ID. Changing it later means a new app identity on both stores and on-device data migration, so it is treated as fixed.
