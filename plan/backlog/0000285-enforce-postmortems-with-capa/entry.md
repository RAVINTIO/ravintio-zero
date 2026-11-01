---
title: "Backlog Entry: 0000285 - ship requires a postmortem with all three CAPA types"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000285 - ship requires a postmortem with all three CAPA types

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

The pack tells the orchestrator to run `ravintio-postmortem` after a `Resolved:` line, before ship (`orchestrator-exception-stops.md` step 4). The skills catalogue also names CI failures, P2 self-corrections, and escaped defects as triggers. No run has done so:

- `plan/postmortems/` didn't exist until 2026-10-31, and the human requested every record in it.
- Initiative 0000238 step 4 has `Blocked:` and `Resolved:` lines in its build log, and its build report says `Postmortems: none`. Step 6's report says the same.
- 12 of the 15 steps in initiative 0000238 logged `Rework:` lines, and none led to a postmortem.

The trigger is a line in a reference file, and nothing checks it. Ship lists postmortems but passes when one is missing. A stop resolved outside the step session, as step 6's was, never gets a `Resolved:` line at all.

The postmortem skill also asks for "at least one action". It doesn't require corrective, preventive, and detective actions, or a record of corrective work already done.

## Suggested Action

- Make ship fail when the build log has a `Blocked:`/`Resolved:` pair or a `Rework:` line with no matching `Postmortem: {path}` line.
- Require one action row for each CAPA type in every postmortem. A type with no action says "none, because {reason}".
- Record corrective work done during the run as a done row with its commit or PR.
- When a stop is resolved outside the step session, the next session writes the `Resolved:` line before it continues.

## Wanted outcome

Every stop and every self-correction leaves a postmortem whose actions are filed or recorded. Tests check these conditions:

- Ship fails on a build log with a `Resolved:` line and no `Postmortem:` line.
- The postmortem check fails on a record that lacks a corrective, preventive, or detective row.
- A "none, because" row passes the check.

## Why Deferred

The human asked for it on 2026-10-31, after the initiative 0000238 postmortems. No run is active.
