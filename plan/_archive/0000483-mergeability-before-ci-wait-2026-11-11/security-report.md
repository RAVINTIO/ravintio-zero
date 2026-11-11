---
title: "Security Report - 0000483-mergeability-before-ci-wait"
summary: "Findings for the mergeability check before a CI wait."
---
# Security Report - 0000483-mergeability-before-ci-wait

**Overall risk rating:** low. The change adds one read of existing `gh` output and one timeout to a script, plus text in two documents.

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| The queue reads `mergeable` from `gh pr view` output and compares it with a fixed string | `src/ravintio-zero/scripts/merge-queue.mjs`, `waitForChecks` | Low | The value is compared and never run or written. The call uses an argument array through the existing `gh` helper |
| `MQ_NOCHECKS_MS` comes from the environment | `src/ravintio-zero/scripts/merge-queue.mjs`, `waitForChecks` | Low | `Number()` converts it, and a non-numeric value falls back to the default. The value only sets a timeout |
| Injection, credentials, path traversal, dependencies, data exposure | the changed files | none found | The change adds no library, no file access, and no network call beyond the existing `gh` call |

## Risk register

- R-001 (existing stubs lack `mergeable`): mitigated. Nine queue suites pass.
- R-002 (`UNKNOWN` stops the queue): mitigated. The queue stops only on `CONFLICTING`.
- R-003 (slow runner): open by design. `MQ_NOCHECKS_MS` sets the limit and a rerun resumes.
- R-004 (skill-text cap): mitigated. `test-0000384-skill-text.sh` passes.

## Top actions before production

None.
