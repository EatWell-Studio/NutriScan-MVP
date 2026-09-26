# ADR 0019: Android-first demo, iOS afterwards

- Status: Accepted
- Date: 2026-09-26
- Decision: D20

## Decision

- The MVP demo on 2026-10-14 runs on an Android device.
- Until the demo, only Android is built and tested on real devices. The iOS version (signing, camera and permissions, device testing) follows after the demo.
- The PRD platform requirement is unchanged: Android and iOS from one codebase.

## Consequences

- No Android-only logic in shared code; platform differences go behind small adapters so iOS can be added without restructuring.
- `mobile_scanner` 7.x uses Apple Vision with AVFoundation on iOS (no ML Kit), which satisfies PRD rule 6; this was verified from the package changelog and source.
- The estimates in DEV_PLAN §4 assume Android only.

## References

- [mobile_scanner changelog](https://pub.dev/packages/mobile_scanner/changelog) (7.0.0: "[iOS/macOS] Migrated to the Vision API")
- [MobileScannerPlugin.swift at v7.4.2](https://github.com/juliansteenbakker/mobile_scanner/blob/v7.4.2/darwin/mobile_scanner/Sources/mobile_scanner/MobileScannerPlugin.swift)
