---
title: "Retrospective: 2026-11-11 - Ship removal needs human approval"
summary: "A blameless review of the ship removal run. The run files no change."
status: "closed"
---
# Retrospective: 2026-11-11 - Ship removal needs human approval

**Mode:** run
**Subject:** 0000519-ship-removal-needs-human-approval
**Date:** 2026-11-11

## Summary

Ship Step 4 now removes `plan/current/` with `git rm -r -q plan/current`, and P2 writes docs before the full suite starts. The run needed one rework and one postmortem.

## What helped

- The backlog entry named the exact command and the test to write, so P0 needed no questions (build log P0 block).
- The archive step ran `git rm -r -q plan/current` in this session with no refusal from the safety check (the `Archive the run` commit).

## What slowed the work

- The full suite took about 60 minutes because other steps and the baseline run shared the machine (build log P2 notes).
- A new suite used a root path that fails for the installed copy of the suite (`plan/postmortems/2026-11-11-installed-copy-check-used-wrong-root.md`).

## Keep

- Write the docs first, then run the full suite, so the tree stays unchanged during the run (build log P2 block).

## Change

None. The full suite caught the rework before the PR, and the postmortem files no action.

## Actions

None filed.
