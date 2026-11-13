---
title: "Retrospective: 2026-11-11 - Parallel steps reserve distinct ids"
summary: "A blameless review of the id collision run, and the change it files."
status: "open"
---
# Retrospective: 2026-11-11 - Parallel steps reserve distinct ids

**Mode:** run
**Subject:** 0000485-adr-number-collision
**Date:** 2026-11-11

## Summary

The queue now renumbers an ADR or a backlog entry that a PR added under an id the base also holds. The initiative branch took ADR 0310 during the run, so the new module renumbered its own ADR.

## What helped

- Running the module on the real merge of the initiative branch found a missed case before the queue ran it (build log P3 Merge line).
- Earlier step archives gave a model for each artifact, so P0 and P1 took about two minutes (`plan/_archive/0000472-ci-duration-metric-2026-11-10/`).

## What slowed the work

- The initiative branch moved during P3 with two merges. The conflict resolution on the counters and living docs took a manual pass (commit ea4959c6).
- The full suite in a clean clone takes about 20 minutes, and the baseline run took as long (build log P3 note).
- `gate-write` blocked a command that wrote a plan file after a `cd`, so one batch of writes ran twice.

## Keep

- Run a new module on the real merge before the PR. It found the rename case that no test world covered (commit 14b5bf58).

## Change

- Make the plan name a test world for each change shape when a unit reads a git diff (backlog entry 0000516).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Plan names add, rename, and delete test worlds for a diff reader | plan skill | `src/ravintio-zero/skills/ravintio-plan/SKILL.md` | A suite that checks the test impact scan text | `plan/backlog/0000516-plan-lists-change-shapes/entry.md`, from the 0000485 retrospective |
