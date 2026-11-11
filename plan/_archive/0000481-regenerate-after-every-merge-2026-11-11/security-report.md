---
title: "Security Report - 0000481-regenerate-after-every-merge"
summary: "Security review of the regeneration after every base merge."
status: "active"
version: "0.1.0"
---
# Security Report - 0000481-regenerate-after-every-merge

**Overall risk rating:** low

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Injection through git arguments | `src/ravintio-zero/scripts/shared-files.mjs` `regenerateSharedFiles` | Low | Every git call takes an argument array. The commit subject follows `-m` and the paths follow `--`. |
| Subject built from chart text | `src/ravintio-zero/scripts/merge-queue.mjs` `regenerateAfterMerge` | Low | The subject uses the first 7 characters of the Feature id. The id passed the title check against the chart. |
| Counter text written to a file | `shared-files.mjs` counter branch | Low | The module writes a value only if it matches `^\d+$`. |
| Path traversal | `shared-files.mjs` | Low | The paths come from the constants `COUNTERS` and `BACKLOG_INDEX`. No input builds a path. |
| Credentials, dependencies, data exposure | none | none | The change adds no dependency, credential use, or logging of file content. |

## Risk register cross-check

- R-001 (CI restarts after the regeneration commit): accepted. The queue waits on the pushed head.
- R-002 (non-deterministic index): mitigated by the AC-2 test. A second run adds no commit.

## Top actions before production

None.
