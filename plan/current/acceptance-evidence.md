---
title: "Acceptance Evidence - 0000315-isolated-test-state"
summary: "Checks, security, and execution evidence for the step."
---
# Acceptance Evidence - 0000315-isolated-test-state

## Checks

- Full suite with `RAVINTIO_INITIATIVE_STEP=1` set: 231 feature suites passed, 0 failed. Regression: 19 of 19.
- Self-corrections: 2. The first full run failed `test-0000164-req-008` because the runner used process substitution. The runner now feeds its loop with a herestring. Clearing `RAVINTIO_TEST_QUIET` also broke `test-0000151-req-008`, so it now passes through.

## Security

- No critical or high finding. Overall risk: low. See `plan/current/security-report.md`.

## Execution evidence

- The full run left tracked and untracked files unchanged and printed no `Tree changed` line.
- Probe suites saw `RAVINTIO_INITIATIVE_STEP` and an unlisted variable unset in `run-tests.sh` and `run-tests.ps1`.
- A suite that left an untracked file or edited a tracked file failed the run and named the path.
- A copy of `hook-enforcement.md` without the rule phrases fails `test-0000164-req-007`.
- No criterion is `not-verifiable`.
