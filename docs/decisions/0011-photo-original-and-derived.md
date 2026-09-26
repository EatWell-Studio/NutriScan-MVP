# ADR 0011: Keep original and derived images, strip EXIF

- Status: Accepted
- Date: 2026-09-26
- Decision: D10

## Decision

- Each capture keeps two files: the **original image** and the **derived image**, which is the one sent to the model. Both are stored locally and in the bucket, and both have a recorded sha256.
- The raw JSON records which file was sent to the model (`input_image_sha256`).
- **The derived image stays within the selected model's native limits.** There are two limits: the long-edge pixel limit and the visual-token limit (`⌈w/28⌉ × ⌈h/28⌉`). Both are read from `schema/eval/models.yaml`. If either limit is exceeded, the API downscales the image before processing, and the bytes the model actually sees no longer match the archive. The official vision docs are authoritative for these limits.
- **Both files have their EXIF removed**, including GPS, because the repository is public. First apply the EXIF orientation to the pixels, then strip EXIF. The sha256 is computed after stripping.
- The `camera` plugin saves photos to a temporary directory. Move each photo to the app documents directory immediately after capture.

## Consequences

- Storage and upload volume roughly double, which is acceptable at personal scale.
- If a new model has different limits, regenerate the derived image from the original. Older derived images and raw JSON stay as they are.

## References

- [Vision: image size and token calculation](https://platform.claude.com/docs/en/build-with-claude/vision)
