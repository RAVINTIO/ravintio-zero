---
title: "Security Report - 0000472-ci-duration-metric"
summary: "Findings for the CI duration metric."
---
# Security Report - 0000472-ci-duration-metric

**Overall risk rating:** low. The change adds one regex and one report row to a read-only script, two standards lines, and one ship skill line.

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| The script matches `CI duration:` lines from the build log with a regex and prints the run id | `src/ravintio-zero/scripts/workflow-metrics.mjs`, `CI_DURATION` | Low | The regex accepts digits for the seconds and a run token with no comma, parenthesis, or space. The script only prints the token and writes no file |
| The ship skill tells the agent to run `gh run view {run-id}` | `src/ravintio-zero/skills/ravintio-ship/SKILL.md`, Step 9 | Low | The command only reads. The run id comes from the PR's own checks |
| Injection, credentials, path traversal, dependencies, data exposure | the changed files | none found | The change adds no library, no file access, and no network call in code |

## Risk register

- R-001 (custom standards files lack the key): mitigated. The one suite that writes standards files now writes the key. All related suites pass.
- R-002 (skill-text total over 1720): mitigated. `test-0000384-skill-text.sh` passes.
- R-003 (`gh` returns no run): mitigated. The skill writes no marker and the report shows `0` and `ok`.

## Top actions before production

None.
