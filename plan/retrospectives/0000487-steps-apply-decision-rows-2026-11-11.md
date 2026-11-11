---
title: "Retrospective: 2026-11-11 - Steps apply decision rows"
summary: "A blameless review of the decision rows run, and the change it files."
status: "open"
---
# Retrospective: 2026-11-11 - Steps apply decision rows

**Mode:** run
**Subject:** 0000487-steps-apply-decision-rows
**Date:** 2026-11-11

## Summary

The run added a module that lists decision rows for a step. It also added a build-log check that fails a missed row. Ship stopped once when the safety check refused the removal of `plan/current/`.

## What helped

- The clean-clone suite ran in the background while the agent wrote the reports (build log P3 notes).
- The merge of the initiative branch kept the run current. The step renumbered its ADR to 0314 and no conflict stayed open (build log P4 deviation line).

## What slowed the work

- The full suite took over 30 minutes because three other steps shared the machine (build log P2 notes).
- The safety check refused the removal of `plan/current/`, so the step waited for the coordinator (postmortem `plan/postmortems/2026-11-11-ship-removal-refused.md`).
- P2 says to write docs while the full suite runs, but the runner fails on a changed tree.

## Keep

- Run the clean-clone suite in the background and write the reports in the meantime (build log P3 notes).

## Change

- Name a removal command that the safety check accepts in ship Step 4, and fix the P2 docs timing (backlog entry 0000518).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Name `git rm -r` in ship Step 4 and fix the P2 docs timing | pack maintainer | `.claude/skills/ravintio-ship/SKILL.md` | A ship run in a step session | `plan/backlog/0000518-ship-removal-needs-human-approval/entry.md`, from the 0000487 retrospective |
