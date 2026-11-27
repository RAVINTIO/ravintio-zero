---
title: "Postmortem: 2026-11-16 - Pin update after renumbering logged as rework"
summary: "A blameless record of why a planned pin update needed a postmortem, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-16 - Pin update after renumbering logged as rework

> Path: `plan/postmortems/2026-11-16-pin-update-after-renumbering-logged-as-rework.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** P2 self-correction
**Feature:** 0000559-start-baseline-first
**Date:** 2026-11-16

## Summary

The step renumbered the start actions. Two suites pinned the old numbers, `test-0000151-req-011` and `test-0000321-req-004-pickup-text`. The step updated both pins, as the chart decision row requires. No defect got through.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-16T05:36:07Z | The plan notes the renumbering and lists the suites that grep fixed phrases. It misses the two number pins. | `plan/current/execution-plan.md` |
| 2026-11-16T05:38:00Z | The impacted suites fail on the new numbers. The step updates both pins. | build-log P2 `Rework:` line |
| 2026-11-16T06:20:00Z | `build-log-check.mjs` fails on the `Rework:` line with no `Postmortem:` line. | `build-log-check.mjs` output |

First missed chance to catch it: P1 Plan. The test impact scan has no cause for a renumbered list.

## 5 whys

1. Two suites failed after the renumbering, and ship then needed a postmortem.
2. The suites pin action numbers and a fixture of the old list.
3. The plan did not list them, because the scan has no cause for a renumbered list.
4. The chart decision row says to log a `Rework:` line for a pin update.
5. The marker set has no marker for a planned pin update, so the check reads it as a failure.

**Gap:** The scan has no cause for a renumbered list, and the marker set has no marker for a planned pin update.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Update both pins and write this record | done | step 15 | `ravintio-zero/tests/` | The two suites and `build-log-check.mjs` pass | this branch |
| preventive | Add a `Pin update:` marker and change the chart decision row | filed | pipeline | `ravintio-zero/scripts/build-log-check.mjs` | A planned pin update with no postmortem passes the check | 0000586 |
| detective | none, because the impacted suites failed during P2 | none | none | none | none | none |
