---
title: "Postmortem: 2026-11-11 - Hook change missed pinning suites"
summary: "A blameless record of why six suites that pin hook counts and the reply margin were found in P2 and not in P1, and the actions that close the gap."
status: "open"
---
# Postmortem: 2026-11-11 - Hook change missed pinning suites

> Path: `plan/postmortems/2026-11-11-hook-change-missed-pinning-suites.md`. Written by `ravintio-postmortem`.

**Trigger:** P2 self-correction
**Feature:** 0000499-reply-times-match-clock
**Date:** 2026-11-11

## Summary

Step 51 added a `PostToolUse` hook and cut the reply-time margin to 2 minutes. Six suites pinned the old counts and margin. The Test impact scan named three, so the full suite found the rest in P2 and the step reworked them.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-11T08:45:15Z | P1 listed three frozen-line suites and no hook count suite | `plan/_archive/0000499-reply-times-match-clock-2026-11-11/execution-plan.md` |
| 2026-11-11T09:00:00Z | The sharded full suite reported ten failing suites | `Tests run: full suite` line in the build log |
| 2026-11-11T09:17:39Z | The step updated the pins and logged a Rework line | `Rework: REQ-003` line in the build log |

First missed chance to catch it: the P1 Test impact scan. It has no cause for a hook change.

## 5 whys

1. Ten suites failed in the first full run.
2. They pinned a hook count, a settings filter count, a fixture, or the old margin.
3. The Test impact scan named three of them.
4. The scan lists causes such as skill count and size cap, and none covers a new or changed hook.
5. The `ravintio-plan` skill has no test impact cause for a hook change.

**Gap:** The Test impact scan in `ravintio-plan` has no cause for a hook change.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Update each pinning suite and the generated pack facts | done | step 51 | `src/ravintio-zero/tests/` | the clean-clone full suite | 68f11e37 |
| preventive | Add a hook change cause to the Test impact scan | filed | pack maintainer | `.claude/skills/ravintio-plan/SKILL.md` | a plan run that adds a hook | 0000523 |
| detective | none, because the full suite in P2 already finds a pin that moved | none | none | none | none | none |
