---
title: "Retrospective: 2026-11-10 - refuse a step merge outside the queue"
summary: "A blameless review of step 33, which made merge-guard refuse a merge from a step session."
status: "open"
---
# Retrospective: 2026-11-10 - refuse a step merge outside the queue

**Mode:** run
**Subject:** 0000458-refuse-step-merge-outside-queue
**Date:** 2026-11-10

## Summary

`merge-guard` now blocks every merge command when `RAVINTIO_INITIATIVE_QUEUE` is `1`, so only the merge queue merges a step PR. The step ran inline in five phases with two self-corrections.

## What helped

- The backlog entry named the variable, the refusal, and the queue test, so P0 had no open question (`plan/_archive/0000458-refuse-step-merge-outside-queue-2026-11-10/discovery.md`).
- A clean-clone run with the variable set found both regressions before CI (build log, P3 block).

## What slowed the work

- Five existing guard suites inherited the variable from the step session and failed. Each needed an `unset` line (`test-0000043-req-006-merge-guard-hook.sh` and four more).
- A fixture pins a line of the invocation reference, so the first edit failed `test-0000151-req-011-orchestrator-references-split.sh`.
- The full suite takes about 25 minutes in a clean clone, and I ran it twice.

## Keep

- Run the full suite in a clean clone with the step environment, because it shows what a step session sees.

## Change

- Run the guard and fixture suites right after a hook edit, before the full suite.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Run the suites that pin the edited file first | implementer | `ravintio-implement` | The test impact table in the execution plan | not filed |
