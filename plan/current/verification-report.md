---
title: "Verification report - 0000386-unit-dispatch"
summary: "Each acceptance criterion, how it was run, and what was observed."
---
# Verification report - 0000386-unit-dispatch

Started: no service. Every check ran a script or a test on the committed tree.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 | `test-0000386-req-001-inline-tdd-path.sh` reads the skill rule anchors | verified | Exit 0, 15 assertions passed |
| REQ-001 AC-2 | `build-log-check.mjs` on a temp log with RED, GREEN, and an inline Done line | verified | No finding for the unit |
| REQ-001 AC-3 | Same script on a log with GREEN and no RED | verified | Exit 1, finding names the unit |
| REQ-002 AC-1 | Test parses the tier and effort table | verified | 16 of 16 class and score pairs hold one value |
| REQ-002 AC-2 | Test reads the standards, template, and skill | verified | Each shows the `{class}, {tier}, {effort}` form |
| REQ-002 AC-3 | `resume-detect.mjs` on a temp repo with a classified Done line | verified | No `unit in progress` line. `REQ-002 inline` reads as a readable name. |
| REQ-003 AC-1 | `workflow-metrics.mjs` on this run folder | verified | Section lists `code`, `primary`, 3 units and 1 `unclassified` unit |
| REQ-003 AC-2 | Test with a Rework marker after a classified Done line | verified | The matching row shows one rework |
| REQ-003 AC-3 | Test with legacy Done lines | verified | Exit 0, lines counted as `unclassified`, governance table unchanged |

Full suite: 4 local shards in a clean clone of `HEAD`. No new failing suite against `plan/current/baseline-failures.md`. Inherited: `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`.
