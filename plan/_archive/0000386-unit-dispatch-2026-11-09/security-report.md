---
title: "Security report - 0000386-unit-dispatch"
summary: "Findings for the scripts and text this step changes."
---
# Security report - 0000386-unit-dispatch

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| The lazy pattern `(.+?)\s+\(` can run in quadratic time on one very long line with no `(` | `ravintio-zero/scripts/build-log-check.mjs` check 7 | Low | Build logs hold short lines, the script reads a local file, and no network input reaches it. Not mitigated. |
| The `Done:` pattern in the metrics script uses `[^)]*` after fixed classes | `ravintio-zero/scripts/workflow-metrics.mjs` `CLASSIFIED_DONE` | Low | The pattern is anchored and linear. No action. |
| Unit names come from the build log and print to the report | `build-log-check.mjs` findings | Low | The scripts print text only and run no command from it. |

Injection: none. The scripts build no query and run no command from log text. Credentials: none read or written. Path traversal: the scripts read the one path the caller gives. Dependencies: none added. Data exposure: no new output beyond unit names and counts.

## Overall risk rating

Low. No critical or high finding.

## Risk register cross-check

R-001 is mitigated by `test-0000386-req-002-unit-class-tier-effort.sh`. R-002 stays open until runs supply evidence. R-003 is mitigated by the two-marker check. R-004 stays open until the driver reruns setup.
