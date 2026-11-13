---
title: "Postmortem: 2026-11-13 - Driver summary broke suites that read the last line"
summary: "A blameless record of why five existing suites failed in the full run, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-13 - Driver summary broke suites that read the last line

> Path: `plan/postmortems/2026-11-13-summary-broke-last-line-suites.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** P2 self-correction
**Feature:** 0000511-driver-stop-summary
**Date:** 2026-11-13

## Summary

The first design printed the summary block after the last driver line. Five existing suites read the last line and failed in the full run. The fix moved the block before the final line and cost one extra 25-minute full run.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-13T02:52Z | The summary prints at the exit handlers, after the last line. The new suite passes. | commit f19089e1 |
| 2026-11-13T03:18Z | The full run reports 5 `new:` suites against the baseline. | `baseline-failures.mjs check` output |
| 2026-11-13T03:19Z | The agent moves the block before the final line in the driver. | commit 598d2c03 |
| 2026-11-13T03:20Z | The five suites pass again with no test change. | build-log P2 `Rework:` line |

First missed chance to catch it: P1 Plan. The test impact table listed "none found" for the added driver lines, so no step searched the tests for readers of the last line.

## 5 whys

1. Five existing suites failed after the change.
2. They assert that the stop line or the `I-E Delivery:` line is the last line, and the block came after it.
3. The design placed the block at the exit handlers without a check for readers of the final line.
4. The plan's test impact table found suites only by a changed file or a named test, and "added printed lines" had no search rule.
5. The plan skill has no rule to search the tests folder for suites that read the order or the text of printed lines.

**Gap:** The plan skill's test impact step has no cause for changes to printed output.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Print the block before the final line | done | driver | `src/ravintio-zero/scripts/initiative-run.mjs` | The five suites and the new suite pass | commit 598d2c03 |
| preventive | Add an output-order cause to the plan skill's test impact step | filed | plan skill | `ravintio-zero/skills/ravintio-plan/SKILL.md` | A plan for a printed-line change lists the suites that read it | 0000533 |
| detective | none, because the full run and `baseline-failures.mjs check` already caught the failures before P3 | none | none | none | none | none |
