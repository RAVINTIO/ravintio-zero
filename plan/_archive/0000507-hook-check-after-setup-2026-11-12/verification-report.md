# Verification report - 0000507-hook-check-after-setup

## What the agent started

- `node ravintio-zero/scripts/hook-check.mjs` against this repo, and against two temporary copies of its `.claude/` folder.
- The two new suites and the three nearest driver suites with bash.
- No server, container, or network service. The feature has none.

## Per criterion

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 all hooks run | CLI run against this repo | verified | 15 hooks ran, 15 passed, exit 0 |
| REQ-001 AC-2 sample per event and matcher | Test stubs that record stdin | verified | The Write, Bash, and Stop stubs each saw their own `tool_name` or `hook_event_name` |
| REQ-001 AC-3 bad settings file | CLI run against a copy with `{bad` as settings | verified | One stderr line that names the file, exit 2 (suite check) |
| REQ-002 AC-1 deliberate block passes | Test stub that exits 2 | verified | Verdict pass, exit 0 |
| REQ-002 AC-2 missing script fails | CLI run against a copy with `gate-write.mjs` deleted | verified | 3 guard hooks failed with a `guard-run:` line, exit 1 |
| REQ-002 AC-3 other exit code fails | Test stub that exits 1 | verified | Verdict fail, exit 1 |
| REQ-003 AC-1 pass carries on | Driver suite with a stub check that exits 0 | verified | The ran line prints and step 2 starts |
| REQ-003 AC-2 failure stops | Driver suite with a stub check that exits 1 | verified | `I-D Advance: Blocked: hook check failed after setup:` prints, exit 1, step 2 does not start |
| REQ-003 AC-3 no early run | Driver suite with a failing setup command | verified | The check log file does not exist |

## Finding from execution

A first run against a copy with a deleted guard script reported 15 passed. `guard-run.mjs` exits 2 for a guard it cannot run, so the plain exit 2 rule passed the failure. The agent added the launcher-line rule, a test, and the doc changes (rework logged in the build log). The same copy now fails with exit 1.

## Not verifiable

None. The real driver loop with a live merge queue did not run. The driver suites cover the same code path with stubs.
