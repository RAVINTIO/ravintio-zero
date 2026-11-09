---
title: "Backlog Entry: 0000412 - ship waits for CI before it archives the run"
summary: "A step can fix its own CI because ship archives plan/current/ only after green CI."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000412 - ship waits for CI before it archives the run

**Source feature:** 0000382-install-lifecycle
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-08

---

## Problem

Ship archives `plan/current/` before it raises the PR and waits for CI. After the archive, `gate-write` rejects code edits because `plan/current/design.md` is gone. The chart field `**Step CI fixes:** allowed` can then never apply. Step 6 of initiative 0000360 hit this on PR #136 and blocked three times.

Step 6 also wrote `ready` straight after `gh pr create`. It never ran `gh pr checks --watch`, which roadmap standards I-D Advance step 4.2 requires. Nothing checked the skip.

See `plan/postmortems/2026-11-08-archived-step-cannot-fix-ci.md`.

## Suggested Action

Pick one at pickup:

- Move the archive after green CI in `ravintio-ship`. The archive commit then becomes the last push before `ready`.
- Keep the order, and define a reopen procedure in the roadmap standards. The step copies `design.md` and `build-log.md` back from its archive, fixes, pushes, and archives again. `gate-write` accepts it.

In both cases the step refuses to write `ready` until every check on the PR head passes.

## Wanted outcome

- A test shows a step with a failing check pushing a fix with no human route.
- A test shows a step refusing to write `ready` while a check is pending or failed.

## Why Deferred

The human asked for it as a postmortem action during I-C Run of initiative 0000360.
