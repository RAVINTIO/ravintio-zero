---
title: "Retrospective: 2026-11-15 - failed queue run leaves written files"
summary: "A blameless review of the 0000546 run and the change it files."
status: "open"
---
# Retrospective: 2026-11-15 - failed queue run leaves written files

> Path: `plan/retrospectives/0000546-queue-failure-leaves-dirty-files-2026-11-15.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000546-queue-failure-leaves-dirty-files
**Date:** 2026-11-15

## Summary

The run made the merge queue restore the files it wrote when a run fails before the commit lands. CI failed once on the source-tree sync check, and one fix cleared it.

## What helped

- The existing queue test world and fake `gh` let the new test reach RED and GREEN in minutes (build log, P2 block).
- The chart Decisions row set the restore scope, so the step asked no question (build log, P0 Decision lines).

## What slowed the work

- The plan assumed tests live only in `ravintio-zero/tests/`. CI `validate-branch` failed on `sync-installed.mjs --check` (build log, P4 Deviation line).
- The full suite and the clean-clone suite each took about 20 minutes, in sequence (build log, P2 and P3 blocks).

## Keep

- Keep the Test impact scan. It listed the five suites that read the queue output, and all passed (execution plan, `## Test impact`).

## Change

- Add a Test impact cause that names the source copy of a new test (`plan/backlog/0000590-plan-names-both-test-trees/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Name both test trees for a new test | pack maintainer | `ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md` | a test that reads the cause | backlog 0000590, which cites this retrospective |
