# ADR 0001: Object storage on Backblaze B2 (EU)

- Status: Accepted, effective once the P0-6 tests pass
- Date: 2026-09-26
- Decision: D3

## Context

F3 needs an S3-compatible object storage bucket in an EU region. It will hold the only non-reproducible assets: photos and raw JSON. The storage and credentials must guarantee that objects are only ever added, never deleted. Code discipline is not enough.

## Decision

- Use Backblaze B2 in the EU Central region, through its S3-compatible API.
- The bucket keeps all file versions.
- Each developer gets their own application key with only the minimum permissions needed to write. The key has no `deleteFiles` and no permission to change bucket settings, and each key can be revoked on its own.
- Do not spend more time evaluating Cloudflare R2 or Hetzner. If B2 passes the tests, this decision is final. If it fails, reopen this ADR.

## P0-6 test results (to be filled in)

| # | Test | Expected | Result |
| --- | --- | --- | --- |
| 1 | Delete an object with the write-only key | Rejected | |
| 2 | PUT to an existing name | A new version is created and the old version remains (confirm by listing versions with the master key) | |
| 3 | Hide a file with the write-only key (native B2 hide, or an S3 DELETE without a version ID) | Record the actual behavior. Hide may need only write permission. If it works, a leaked key could hide files (older versions still remain); record this as a risk | |
| 4 | Change lifecycle rules with the write-only key | Rejected (lifecycle rules can purge old versions, so this key must not have that permission) | |
| 5 | Revoke one of the keys | The other key is unaffected | |

## Consequences

- During the MVP, the write-only key is compiled into each developer's own app build. If a key leaks, the worst case is someone writing junk into the bucket. Existing data is not lost.
- Before any external distribution, the server-side proxy issues presigned URLs instead (ADR 0015), and clients no longer hold a key.

## References

- During P0-6, add links to the official B2 docs on application key capabilities and file versions.
