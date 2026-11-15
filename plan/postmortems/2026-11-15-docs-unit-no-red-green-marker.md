---
title: "Postmortem: 2026-11-15 - docs unit has no RED or GREEN marker"
summary: "A blameless record of why the ship check failed on a docs unit with no RED or GREEN line, and the actions that close the gap."
status: "open"
---
# Postmortem: 2026-11-15 - docs unit has no RED or GREEN marker

> Path: `plan/postmortems/2026-11-15-docs-unit-no-red-green-marker.md`. Written by `ravintio-postmortem`.

**Trigger:** Blocked stop
**Feature:** 0000573-require-unit-reports
**Date:** 2026-11-15

## Summary

The P4 ship check failed because REQ-001 U3 (docs) had no RED or GREEN line in the build log. The run stopped at ship until the coordinator logged the markers.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-14T15:25:24Z | U3 docs unit finished with a Done line and no RED or GREEN line | `plan/current/build-log.md`, P2 block |
| 2026-11-15T13:49:04Z | P2 logged the gap as a Deviation for the human to decide | `plan/current/build-log.md`, P2 block |
| 2026-11-15T14:32:06Z | Ship check failed and the run logged a Blocked line | commit ad4186ef |
| 2026-11-15T16:57:41Z | The coordinator logged RED and GREEN lines for U3 at the human's request | commit 89ff7782 |

First missed chance to catch it: the 2026-11-14T15:25:24Z Done line. P2 could have logged a marker, but the rule gave a docs unit no check to run.

## 5 whys

1. The ship check failed because U3 had no RED or GREEN line.
2. The U3 docs unit has no executable test, so P2 had no result to log.
3. The P2 loop requires RED and GREEN lines for every unit.
4. The loop rules give no marker form for a unit with no executable check.
5. `build-log-check.mjs` and the P2 rules disagree on what a non-test unit logs.

**Gap:** No rule defines the RED and GREEN markers for a unit with no executable check. Backlog 0000410 tracks it.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Log RED and GREEN lines for U3 with a note that the unit has no executable check | done | coordinator | `plan/current/build-log.md` | `build-log-check.mjs` | 89ff7782 |
| preventive | Define the markers a non-test unit logs | filed | pack maintainer | `ravintio-zero/skills/ravintio-implement/` | `build-log-check.mjs` | 0000410 |
| detective | none, because the ship check already caught the gap | none | none | none | none | none |
