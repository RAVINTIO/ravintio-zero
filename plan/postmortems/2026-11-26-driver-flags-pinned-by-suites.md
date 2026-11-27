---
title: "Postmortem: 2026-11-26 - driver flags pinned by suites"
summary: "Eight suites failed after the driver gained a --settings flag and a TMPDIR variable, and the test impact scan did not list them."
status: "closed"
---
# Postmortem: 2026-11-26 - driver flags pinned by suites

> Path: `plan/postmortems/2026-11-26-driver-flags-pinned-by-suites.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** P2 self-correction
**Feature:** 0000583-step-temp-cleanup-after-merge
**Date:** 2026-11-26

## Summary

The new driver passed `--settings` to `claude` and set `TMPDIR`. Seven suites that pin the exact `claude` arguments or the child environment failed, and the backlog index check failed. The full run found them. The agent reworked the suites.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-26T06:56:00Z | The driver change landed with its own four suites green | commit e617774b |
| 2026-11-26T07:02:00Z | The path limit broke every driver suite in a long temp path, and the agent added `RAVINTIO_TEMP_PATH_LIMIT` | commit e20b1dc7 |
| 2026-11-26T07:30:00Z | The first full run failed 9 suites | build log, Rework line of this run |
| 2026-11-26T07:32:00Z | Six stubs strip `--settings`, one test skips `TMPDIR`, and the index was regenerated | commit 1111a90b |

First missed chance to catch it: the test impact scan in `plan/current/execution-plan.md`. It lists suites that pin a changed file, and it did not list suites that pin the driver's child arguments and environment.

## 5 whys

1. Eight suites failed after the driver change.
2. They compare the exact `claude` arguments or the full child environment, and the change added a flag and a variable.
3. The test impact scan matches changed files and pinned text, not the argument list the driver builds.
4. The suites repeat the same stub that logs `$*`, so each pins the argument list on its own.
5. No shared stub or helper owns the argument list, so a change to it has no single place to update.

**Gap:** Six suites each own a copy of the `claude` stub, and the impact scan has no rule for the driver's argument list.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Strip `--settings` in six stubs and skip `TMPDIR` in the environment diff | done | step 38 | `src/ravintio-zero/tests/` | the full suite run | commit 1111a90b |
| preventive | none, because a shared stub for the six suites is a separate refactor and needs its own backlog entry | none | step 38 | none | none | none |
| detective | none, because the full suite already found every failure before ship | none | step 38 | none | none | none |
