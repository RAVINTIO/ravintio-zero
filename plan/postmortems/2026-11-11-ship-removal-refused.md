---
title: "Postmortem: 2026-11-11 - Ship removal refused"
summary: "A blameless record of why ship stopped when the safety check refused to delete plan/current, and the actions that close the gap."
status: "open"
---
# Postmortem: 2026-11-11 - Ship removal refused

> Path: `plan/postmortems/2026-11-11-ship-removal-refused.md`. Written by `ravintio-postmortem`.

**Trigger:** Blocked stop
**Feature:** 0000487-steps-apply-decision-rows
**Date:** 2026-11-11

## Summary

Ship Step 4 could not delete `plan/current/` after the archive copy, so the step stopped with a Blocked line. The coordinator ran the removal with the human's approval and the step resumed.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-11T04:05:35Z | The step finished the archive copy and tried to delete `plan/current/` | `plan/_archive/0000487-steps-apply-decision-rows-2026-11-11/build-log.md` |
| 2026-11-11 | The safety check refused the removal and the step wrote a Blocked line | commit 2c5c8c08 |
| 2026-11-11 | The coordinator ran `git rm -rq plan/current` and queued the finish instruction | `plan/.initiative-queue/finish-ship-step-45/instruction.md` |

First missed chance to catch it: the ship skill. Step 4 names no removal command that the safety check accepts.

## 5 whys

1. The step stopped at the removal of `plan/current/`.
2. The removal command tripped the Claude Code safety check.
3. Ship Step 4 says "delete the contents" and names no command.
4. No run had tested the removal under the safety check in an initiative step.
5. The ship skill has no tested removal command.

**Gap:** Ship Step 4 does not name a removal command that the safety check accepts.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Remove `plan/current/` with `git rm -rq` and commit the archive | done | coordinator | `plan/_archive/0000487-steps-apply-decision-rows-2026-11-11/` | `git ls-files plan/current` is empty | e8c73a9c |
| preventive | Name `git rm -r` in ship Step 4 | filed | pack maintainer | `.claude/skills/ravintio-ship/SKILL.md` | a ship run in a step session | 0000517 |
| detective | none, because the Blocked line already surfaces the stop at once | none | none | none | none | none |
