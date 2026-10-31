---
title: "Security Report - 0000315-isolated-test-state"
summary: "No critical or high finding."
---
# Security Report - 0000315-isolated-test-state

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| The runner passes `RAVINTIO_PWSH` to suites, so it picks the PowerShell program. A suite already ran that program. | `ravintio-zero/tests/run-tests.sh:27-35` | Low | The runner passes no new value and clears every other `RAVINTIO_` variable. |
| The tree check runs `git ls-files` and `git hash-object` on repo paths. It builds no command from file names. | `ravintio-zero/tests/run-tests.sh:38-48` | Low | Paths pass as arguments after `--`, and the loop reads NUL-separated names. |
| The change adds no permission. No hook, guard, or credential path changes. | `ravintio-zero/tests/run-tests.ps1` | Low | Not applicable. |

**Overall risk rating:** low.

**Risk register:** R-001 closed: the full suite shows no suite needed an inherited variable beyond `RAVINTIO_TEST_QUIET`, which now passes through. R-002 closed: the full run left the tree unchanged. R-003 stays accepted.

**Top actions before production:** none.
