---
title: "Retrospective: 2026-11-15 - Path move cause"
summary: "A blameless review of step 21, which added a Path move cause to the plan scan."
status: "open"
---
# Retrospective: 2026-11-15 - Path move cause

**Mode:** run
**Subject:** 0000565-layout-move-test-impact
**Date:** 2026-11-15

## Summary

The step added one cause and one suite. The full suite passed apart from three inherited failures. Two full-suite runs took 40 of the 43 minutes.

## What helped

- The step 20 archive gave a template for every artifact, so P1 and P2 took one minute each (plan/_archive/0000565-layout-move-test-impact-2026-11-15/build-log.md, P1 and P2 blocks).
- The chart's Decisions rows answered every fork with no stop (plan/_archive/0000565-layout-move-test-impact-2026-11-15/build-log.md, P0 block).

## What slowed the work

- The baseline run and the P3 run each took about 20 minutes for a text change (plan/_archive/0000565-layout-move-test-impact-2026-11-15/build-log.md, P3 block).
- `block-forced-add` blocked one archive call, because it passed the archive folder to `git add` as a variable (plan/backlog/0000589-ship-archive-git-add-literal-paths/entry.md).

## Keep

- The reference file for scan causes keeps each step small (plan/_archive/0000565-layout-move-test-impact-2026-11-15/execution-plan.md, test impact table).

## Change

- Ship Step 4 should say to write literal `git add` paths (plan/backlog/0000589-ship-archive-git-add-literal-paths/entry.md).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Write literal `git add` paths in ship Step 4 | ship skill | `ravintio-zero/skills/ravintio-ship/SKILL.md` | A standards test on the sentence | 0000589, from retrospective 0000565-layout-move-test-impact-2026-11-15 |
