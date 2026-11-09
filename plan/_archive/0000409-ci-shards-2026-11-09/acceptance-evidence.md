# Acceptance evidence - 0000409-ci-shards

## Checks

- Suites: 362 of 364 passed in a clean clone, run in 4 local shards.
- The two failures, `test-0000037-req-004` and `test-0000318-req-004`, also fail on the base commit.
- Self-corrections: 2. One test expectation was wrong, and the first CI run missed the 7-minute target.

## Security

No critical or high finding. See `security-report.md`.

## Execution

- CI on PR #144 at `e3786225`: 4 bash shards took 2.0 to 2.8 minutes, and 4 Windows shards took 2.4 to 4.5 minutes.
- The whole run took 4 minutes 40 seconds, against about 16 minutes before.
- The required checks `bash-suites` and `windows-powershell (powershell)` reported and passed.
- Not verifiable: none.
