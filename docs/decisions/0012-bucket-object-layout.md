# ADR 0012: Bucket object layout

- Status: Accepted
- Date: 2026-09-26
- Decision: D11

## Decision

**Object key**: all files from one capture share a prefix and differ only in suffix.

```
raw/<YYYY>/<MM>/<subject>_<UTC yyyyMMddTHHmmssZ>_<contributor><suffix>
```

- `subject` is the product barcode. **Without a barcode**, use `nobarcode-<product_id>` (product_id is a UUID).
- `contributor` is the developer's GitHub username (`hannesgao`, `hyhcrh`), read from the local `secrets.json`. Keys include the contributor, so two devices scanning the same product in the same second do not collide.
- The timestamp is generated at capture time and stored in the local `photos` row. Re-uploads use the same key.

**Suffixes**

| Suffix | Content |
| --- | --- |
| `.orig.jpg` | Original image (EXIF stripped) |
| `.jpg` | Derived image, the one sent to the model (EXIF stripped) |
| `.raw.json` | See below |
| `_confirmed.v<N>.json` | Result after user confirmation; N = that product's `nutrient_records.version` |

**`.raw.json` content**: the verbatim API response, plus `model`, `effort`, `prompt_version`, `schema_version`, `input_image_sha256`, `original_sha256`, `input_tokens`, `output_tokens`, `latency_ms`, `contributor` and `requested_at`.

**`_confirmed.v<N>.json` content**: all normalized field values, which fields the user edited, `provenance`, `nutrient_record_id`, `version`, `contributor`, `confirmed_at` and `schema_version`.

**Later edits**: when a user edit creates a new version, append another `_confirmed.v<N+1>.json` under that capture's prefix. Never overwrite earlier files.

**Manual input**: if a photo was taken earlier, upload the photos and `_confirmed.v<N>.json`, with no `.raw.json`. If no photo was taken, the prefix uses the confirmation time as its timestamp, and only `_confirmed.v<N>.json` is uploaded.

## Consequences

- The key rules live in `BucketKeys` (C-5, shared contract). Both tracks call it instead of building strings themselves.
- The bucket client exposes only `put`.
