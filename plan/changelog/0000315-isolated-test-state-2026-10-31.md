# Changelog (0000315-isolated-test-state, 31 Oct 2026)

**Feature:** Isolated test state
**Version:** 0.41.2
**PR:** #84

## What changed

- `run-tests.sh` and `run-tests.ps1` remove every `RAVINTIO_` variable from the environment of each suite. `RAVINTIO_PWSH`, `RAVINTIO_TIMING_FILE`, and `RAVINTIO_TEST_QUIET` pass through.
- Both runners compare tracked and untracked files before the first suite and after the last. If a suite changes one, the run fails and prints `Tree changed during the run: {path}`.
- `test-0000164-req-007` checks `hook-enforcement.md`, `pipeline-reference.md`, and `project-operations.md`. It no longer reads the generated `CLAUDE.md`, and it fails when the rule phrases leave `hook-enforcement.md`.
- Two new test files cover the environment clear and the tree check. `ravintio-zero/tests/README.md` describes both.

## Why

Test results depended on the session. A step session set `RAVINTIO_INITIATIVE_STEP=1`, a nested runner inherited `RAVINTIO_TEST_QUIET=1`, and one test run moved `plan/backlog/.next-id`. `test-0000164-req-007` also failed on any machine with a generated `CLAUDE.md`. Backlog entries 0000309 and 0000267 asked for the fix.

## Deviations

- `RAVINTIO_TEST_QUIET` passes through to suites. `assert.sh` reads it to hide PASS lines, and clearing it broke `test-0000151-req-008`. The brief, scope, REQ-001, and ADR-001 say so.
- The runner feeds its variable loop with a herestring, because `test-0000164-req-008` bans process substitution in loops.
- `run-tests.ps1` relaxes `$ErrorActionPreference` while it calls `git`. Windows PowerShell 5.1 turns git's stderr outside a repository into a terminating error, and CI caught it after the first push.
- REQ-002 needed no per-suite change. No current suite writes the real repo state, and the tree check now proves it on every run.

## Validation results

- 231 feature suites passed and 0 failed, with `RAVINTIO_INITIATIVE_STEP=1` set. The regression suite passed 19 of 19.
- The full run left tracked and untracked files unchanged.
- No critical or high security finding.
- Two self-correction cycles, both in P2.

## Skipped phases

None
