# Acceptance evidence - 0000420-version-both-copies

## Checks

- Suites: 393 of 395 passed in a clean clone, run in 4 shards.
- The two failures also fail on the base commit.
- Self-corrections: 0.

## Security

No findings. See `security-report.md`.

## Execution

- The new suite fails 8 of 13 checks before the change and passes 13 of 13 after it.
- `sync-installed.mjs --check` passes after the change.
- Not verifiable here: a live queue bump. Step 21's merge shows it.
