---
title: "Security Report - 0000464-merge-queue-test-gaps"
summary: "Findings for the dash check in merge-queue.mjs and the new tests."
---
# Security Report - 0000464-merge-queue-test-gaps

**Overall risk rating:** low. The change adds one check to `merge-queue.mjs` and two test files.

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| A ref name from `gh` reached `git fetch` and `git switch` without a dash check | `src/ravintio-zero/scripts/merge-queue.mjs`, `cmdRun` | Low | The new check throws a `Stop` for a head or base that starts with `-` or is not a string, before the first `git` call that uses either |
| The stub `version-files.mjs` in the test writes under a temporary folder | `src/ravintio-zero/tests/test-0000464-req-001-002-queue-branches.sh` | Low | The stub writes only to the test's own `product.yml` in a `mktemp` folder, and the trap removes the folder |
| Injection, credentials, path traversal, dependencies, data exposure | the changed files | none found | The change adds no library, no network call, and no credential. `git` and `gh` still run through `execFileSync` with an argument list |

## Risk register

- R-001 (no input reaches the post-set check): mitigated. The stub seam reaches it, and the suite fails when you remove the check.
- R-002 (the dash check changes a pinned error path): mitigated. The nine queue suites that the plan lists all pass.
- R-003 (a dash name reaches `git` as an option): mitigated by REQ-003.

## Top actions before production

None.
