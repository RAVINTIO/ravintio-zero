---
title: "Retrospective: 2026-11-10 - version files completeness check"
summary: "A blameless review of step 37, which added a test that ties the version list to the real files."
status: "open"
---
# Retrospective: 2026-11-10 - version files completeness check

**Mode:** run
**Subject:** 0000466-version-files-completeness-check
**Date:** 2026-11-10

## Summary

The suite now fails when `version-files.txt` omits a tracked file that carries the product version. The step ran inline in five phases with no self-correction in the code.

## What helped

- The chart row for steps 25 to 41 named the two known failures and the four-shard run. The step skipped the long base run (plan/_archive/0000360-backlog-sweep-initiative-2026-11-13/initiative.md, `## Decisions`).
- Fixture repos with `git update-index --add` needed no git identity, so the test stays safe on runners without one (`src/ravintio-zero/tests/test-0000466-req-001-version-list-complete.sh`).

## What slowed the work

- The forced-add guard blocked `git add` with a variable inside the test text. The step rewrote the fixture helper with `update-index` (build log, P2 block).
- The build log check failed on wall-clock rows and a separator that sat before the P0 markers. The step fixed both after the first run of the check.

## Keep

- Remove one list line from the real list and rerun the test. It proves the test catches the 0000397 failure.

## Change

- Fill each wall-clock row from the Start and End times as the phase closes, so the check passes at its first run.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Fill wall-clock rows when a phase closes | orchestrator | build log | `build-log-check.mjs` passes first time | Not filed. No change to a pack file is needed |
