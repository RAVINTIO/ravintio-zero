---
title: "Verification Report - 0000487-steps-apply-decision-rows"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000487-steps-apply-decision-rows

Method: ran the module and the check on the real chart (`plan/current-initiative/initiative.md`) and on scratch build logs under `/tmp/step45-verify`. The three new suites run both against fixture charts. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 range row | `decision-rows.mjs list --step 40` on the real chart | verified | It printed the `Local suite runs` row from the `25-41` range, exit 0 |
| REQ-001 AC-2 no row | `decision-rows.mjs list --step 45` on the real chart | verified | It printed `none`, exit 0 |
| REQ-001 AC-3 list and single | Module suite | verified | A comma list, a single number, and a range all matched step 3, and a colon in a fork survived |
| REQ-002 AC-1 missed row | `build-log-check.mjs` on a copy of this log renamed to the step 40 feature | verified | The check exited 1 with `Decisions: step 40 has no log line for the row "Local suite runs"` |
| REQ-002 AC-2 logged row | Same log with a `Decision applied` line | verified | The Decisions finding disappeared |
| REQ-002 AC-3 no chart | Check suite, projects with no chart and with a Feature ID not in the chart | verified | No Decisions finding |
| REQ-003 AC-1 start action | Text suite | verified | The start actions file holds the anchor, the command, and the three log lines |
| REQ-003 AC-2 standards | Text suite | verified | Rule `icrun-decision-row` names the module and the check |
