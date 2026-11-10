---
title: "Retrospective: 2026-11-10 - reply time matches the clock"
summary: "A blameless review of step 38, which made the reply hook compare the leading time with the clock."
status: "open"
---
# Retrospective: 2026-11-10 - reply time matches the clock

**Mode:** run
**Subject:** 0000468-reply-time-matches-the-clock
**Date:** 2026-11-10

## Summary

The reply hook now warns when a leading time differs from the clock by more than 5 minutes. The reply rule names `date +%H:%M` in each file that states the form. The step ran inline in five phases with one self-correction, a boot template size cap.

## What helped

- A clock override variable let a suite fix the clock, so the midnight wrap has a test (`test-0000468-req-001-clock-check.sh`, AC-3).
- The test impact scan named the 0000388 suites that used fixed times, so only one suite needed a change (`plan/_archive/0000468-reply-time-matches-the-clock-2026-11-10/execution-plan.md`).

## What slowed the work

- The boot template size cap failed only in the full suite, 25 minutes after the edit (build log, P2 block). The scan did not list `test-0000151-req-011-orchestrator-references-split.sh` for an edit to the boot templates.
- The PR conflicted with the initiative branch, so GitHub started no CI until the step merged the branch in. Another step had also taken ADR 0304, so the step renumbered its ADR by hand.
- The step typed two reply times from memory before it read the clock. This is the failure the feature addresses.

## Keep

- Give each hook check an override variable, so a suite can fix the input it compares.

## Change

- Add the size-cap suite to the test impact scan cause for the boot templates (`ravintio-plan` SKILL.md, Test impact scan).
- Renumber a colliding ADR in the merge queue (`plan/backlog/0000479-adr-number-collision/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Name the boot size-cap suite in the scan | plan skill | `ravintio-plan` SKILL.md | A test that reads the scan list | Not filed. It is an edit to the scan list, which a later step can make |
| Renumber a colliding ADR in the queue | merge queue | `merge-queue.mjs` | A queue test with two ADRs of one number | `plan/backlog/0000479-adr-number-collision/entry.md` |
