---
title: "Retrospective: 2026-11-10 - Add-step writes the full feature id"
summary: "A blameless review of a finished run or initiative, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-10 - Add-step writes the full feature id

**Mode:** run
**Subject:** 0000438-add-step-writes-full-feature-id
**Date:** 2026-11-10

## Summary

The helper now writes `{id}-{slug}` in the Steps row. A test pins the driver pattern to a shared export. The run needed no rework.

## What helped

- A shared `FEATURE_ID` export plus a source comparison test kept the driver file untouched, which avoids the restart stop (`plan/_archive/0000438-add-step-writes-full-feature-id-2026-11-10/scope.md`).
- The chart rows for the step covered every fork, so P0 asked no question (`build-log.md`, Scope Lock lines).

## What slowed the work

- The full suite and the clean-clone run took 43 and 29 minutes while other sessions ran suites on the same machine (`build-report.md`).
- The strict-mode ack prompt arrived mid-run and the write made the suite exit 1 (`build-log.md`, P2 block).
- The prose check rejected three plan records on a passive or a long sentence, which cost three commit retries.

## Keep

- Pin a copy of a pattern to its twin with a test when the file that holds the twin triggers a driver restart (`scope.md`).

## Change

- The ack write should not fail a running suite (backlog entry 0000476).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Ack write mid-suite must not fail the run | pack maintainers | `ravintio-zero/hooks/` and `ravintio-zero/tests/run-tests.sh` | A test that writes the ack mid-run | `plan/backlog/0000476-ack-write-mid-suite-fails-run/entry.md`, naming this retrospective |
