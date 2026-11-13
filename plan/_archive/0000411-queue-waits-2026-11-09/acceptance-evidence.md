# Acceptance evidence - 0000411-queue-waits

## Checks

- Suites: 372 of 375 passed in a clean clone, run in 4 shards.
- Two failures also fail on the base commit. One flake exited 141 under load and passes alone.
- Self-corrections: 1, recorded in `plan/postmortems/2026-11-09-queue-test-fake-missed-ci-wait.md`.

## Security

No findings. See `security-report.md`.

## Execution

- The new suite fails 7 of 9 checks on the old script and passes 9 of 9 on the new one.
- The queue waits for the pushed head, CI, and a `MERGEABLE` answer before it merges, and it retries one refusal.
- Not verifiable here: the live GitHub race. The next queue run in initiative 0000360 shows it.
