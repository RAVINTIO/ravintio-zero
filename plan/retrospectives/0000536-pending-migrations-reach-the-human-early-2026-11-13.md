---
title: "Retrospective: 2026-11-13 - Pending migrations reach the human early"
summary: "A blameless review of step 61 of initiative 0000360, and the change it files."
status: "open"
---
# Retrospective: 2026-11-13 - Pending migrations reach the human early

**Mode:** run
**Subject:** 0000536-pending-migrations-reach-the-human-early
**Date:** 2026-11-13

## Summary

The step shipped in about 80 minutes as PR 200 with green CI. It added the chart-time migration rule, a step rule, and a coordinator rule.

## What helped

- The Decisions-row pattern from `Confirmation:` rows gave the change a ready shape (`docs/adr/0310-*.md`).
- Keeping the old check 1 line verbatim and adding a bullet passed the fixture-pinned tests first time (`build-log.md`, P2 block).
- The clean-clone baseline separated three inherited failures from new ones (`baseline-failures.md`).

## What slowed the work

- The plan listed only `ravintio-zero/`. The full suite then failed on the mirrored tree and the agent redid the mirror and the design paths (`build-log.md`, P2 Deviation line).
- The first full suite ran from `ravintio-zero/tests/`. One suite failed on relative paths and cost a rerun (`build-log.md`, P2 note).
- The suites take about 25 to 35 minutes, so P2 and P3 each waited on one run.

## Keep

- Run the baseline in a clean clone at P0 and start it in the background (`plan/_archive/0000536-pending-migrations-reach-the-human-early-2026-11-13/baseline-failures.md`).

## Change

- The Test impact scan needs a cause for the mirrored pack tree (`plan/backlog/0000539-test-impact-scan-lists-the-mirrored-pack-tree/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Add a mirrored-tree cause to the Test impact scan | plan skill | `ravintio-zero/skills/ravintio-plan/SKILL.md` | A test that reads the cause | 0000539, from this retrospective |
