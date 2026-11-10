---
title: "Retrospective: 2026-11-10 - ship waits for CI before it archives"
summary: "A blameless review of step 30 of initiative 0000360, and the one change it files."
status: "open"
---
# Retrospective: 2026-11-10 - ship waits for CI before it archives

**Mode:** run
**Subject:** 0000452-ci-wait-before-archive
**Date:** 2026-11-10

## Summary

The step moved the archive after green CI in the initiative ship order and added a green-checks rule for `ready`. The work needed no stops.

## What helped

- The chart decision settled the open fork in advance, so P0 had no question (initiative chart, `## Decisions` row for step 30).
- The impact scan named the pinned tests, and only two needed a change (`plan/_archive/0000452-ci-wait-before-archive-2026-11-10/execution-plan.md`).

## What slowed the work

- Each full suite run took about 30 minutes, and the clean clone ran after it (build log, P2 and P3 wall clocks).
- A guard blocked a long shell command and a command with a variable path in `git add`. Each cost one retry (build log, P2 and P4).

## Keep

- The impact scan before the plan. It cut the P2 rework to two pinned tests (`execution-plan.md`).

## Change

- The closing archive push runs the whole CI again, though it changes only `plan/` and the sentinels (ADR-0298, risk R-002).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Run a shorter CI path on a push that changes only `plan/` and sentinels | CI workflow | `ravintio-zero/hooks/ravintio.yml` | A workflow test that a plan-only push skips the suites | `plan/backlog/0000476-plan-only-push-short-ci/entry.md`, naming this retrospective |
