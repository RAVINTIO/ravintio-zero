---
title: "Retrospective: 2026-11-11 - Driver clears a dead lock"
summary: "A blameless review of step 49, which made the driver take a lock whose process no longer runs."
status: "open"
---
# Retrospective: 2026-11-11 - Driver clears a dead lock

> Path: `plan/retrospectives/0000495-driver-clears-dead-lock-2026-11-11.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000495-driver-clears-dead-lock
**Date:** 2026-11-11

## Summary

The driver now takes a lock that names a dead process and still refuses every other lock. The run took 32 minutes with no rework.

## What helped

- The existing `alive(pid)` helper from step 48 made the change small (`src/ravintio-zero/scripts/initiative-run.mjs:659`).
- The fixture in `test-0000043-req-007-roadmap-driver.sh` gave a ready pattern for the new suite.
- Two suite runs in parallel gave the baseline and the result in one wait (build log, P2 notes).

## What slowed the work

- The two full suite runs took about 24 minutes of the 32 (build log, P2 wall clock).
- Pending migration 0009 had no human to confirm it, so the agent skipped it (build log, P0 notes).

## Keep

- Run both full suites together when the change is small and the baseline is unknown.
- Pin refusals with tests for each kind of bad lock before the code change.

## Change

- Record a migration as done in the ledger when the repo already meets its target, so step sessions need no skip.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Ledger rows for migrations 0008 and 0009 | pack maintainers | `plan/state/migrations.md` | resume detection reports no pending migration | none, because the coordinator can add the rows directly |
