---
title: "Verification Report - 0000315-isolated-test-state"
summary: "Each acceptance criterion, run against the live repo."
---
# Verification Report - 0000315-isolated-test-state

I ran the checks in a step session where `RAVINTIO_INITIATIVE_STEP=1` is set, against the live working tree. The repo holds a generated `CLAUDE.md`.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| The suite passes with `RAVINTIO_INITIATIVE_STEP=1` set | Ran `RAVINTIO_TEST_QUIET=1 bash ravintio-zero/tests/run-tests.sh` in this session | verified | 231 feature suites and 19 regression suites passed. Exit 0. |
| The runner clears `RAVINTIO_*` variables and keeps three | Ran `test-0000315-req-001` with probe suites, including a PowerShell probe through `pwsh` | verified | 11 of 11 passed. A probe saw `RAVINTIO_INITIATIVE_STEP` and an unlisted variable unset, and saw `RAVINTIO_PWSH` and `RAVINTIO_TEST_QUIET`. |
| `git status` matches before and after a full run | The full run above reports the check result | verified | The run printed no `Tree changed` line and exited 0. |
| The runner fails on a changed tree | Ran `test-0000315-req-002-003` in temporary git repos | verified | An untracked file and an edited tracked file each gave exit 1 and named the path. An ignored file gave exit 0. |
| `test-0000164-req-007` passes with a generated `CLAUDE.md` | Ran the test in this repo | verified | Passed. The test no longer reads `CLAUDE.md`. |
| `test-0000164-req-007` fails when the phrases leave `hook-enforcement.md` | Ran the check on a copy without the three phrases | verified | The copy failed and named `lacks 'every in-project path'`. |
