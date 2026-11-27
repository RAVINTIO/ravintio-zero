---
title: "Postmortem: 2026-11-15 - A planned pin update logged as rework"
summary: "A blameless record of why a planned test pin update needed a postmortem, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-15 - A planned pin update logged as rework

> Path: `plan/postmortems/2026-11-15-planned-pin-update-logged-as-rework.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** P2 self-correction
**Feature:** 0000553-coordinator-oversight-not-micromanagement
**Date:** 2026-11-15

## Summary

The step changed the text that `test-0000240-req-002-activity-lines.sh` pins, as the plan's test impact table listed. The chart decision required a `Rework:` line, and the build-log check then required this postmortem. No defect got through.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-15T13:19Z | The plan lists the 0000240 pin in `## Test impact`. | `plan/current/execution-plan.md` |
| 2026-11-15T13:21Z | The step edits the skill text and updates the pin. The step logs a `Rework:` line, as the chart decision requires. | build-log P2 `Rework:` line |
| 2026-11-15T14:05Z | `build-log-check.mjs` fails on the `Rework:` line with no `Postmortem:` line. | `build-log-check.mjs` output |

First missed chance to catch it: the chart. The decision row for pin updates names the `Rework:` marker, and the check treats every `Rework:` line as a failure.

## 5 whys

1. Ship stopped on a `Rework:` line with no postmortem.
2. The step logged `Rework:` for a planned pin update.
3. The chart decision row says to log a `Rework:` line for a pin update.
4. The `Rework:` marker means a self-correction, and no other marker fits a planned update.
5. The workflow marker set has no marker for planned pin updates.

**Gap:** The build-log marker set has no marker for a planned pin update, so the check reads it as a failure.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Write this record so ship passes | done | step 9 | `plan/postmortems/2026-11-15-planned-pin-update-logged-as-rework.md` | `build-log-check.mjs` exits 0 | this commit |
| preventive | Add a `Pin update:` marker and change the chart decision row | filed | pipeline | `ravintio-zero/scripts/build-log-check.mjs` | A planned pin update with no postmortem passes the check | 0000586 |
| detective | none, because `build-log-check.mjs` already caught it before archive | none | none | none | none | none |
