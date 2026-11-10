# Acceptance evidence - 0000454-queue-failure-recovery

## Checks

- Suites: 381 passed and 2 failed in a clean clone on macOS.
- The two failures also fail on the base commit.
- `sync-installed.mjs --check` passes.
- `prose-check.mjs check` passes on the changed docs.
- Self-corrections: 0.

## Security

No findings. See `security-report.md`.

## Execution

- The new suite fails 9 of 18 checks before the change and passes 18 of 18 after it.
- The nine other suites that name `merge-queue.mjs` pass.
- OS gap: local macos, CI ubuntu, windows.
- Not verifiable here: a live failed run against GitHub.
