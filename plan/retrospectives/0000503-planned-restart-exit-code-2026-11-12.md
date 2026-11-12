---
title: "Retrospective: 2026-11-12 - Planned restart exits with its own code"
summary: "A blameless review of step 53, which made the driver exit 75 after a planned restart."
status: "open"
---
# Retrospective: 2026-11-12 - Planned restart exits with its own code

> Path: `plan/retrospectives/0000503-planned-restart-exit-code-2026-11-12.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000503-planned-restart-exit-code
**Date:** 2026-11-12

## Summary

The driver now exits 75 after a `Restart:` stop line and keeps exit 1 for every failure. The run took about 33 minutes with one self-correction.

## What helped

- The earlier restart suites gave a serial pattern, and the scheduler fixture gave a concurrent one (`src/ravintio-zero/tests/test-0000250-req-002-driver-restart-stop.sh`).
- One new fixture mode, `blockstop`, covered the failure after a restart hit (`src/ravintio-zero/tests/helpers/scheduler-fixture.sh`).

## What slowed the work

- The baseline run and the full suite took about 22 minutes each (build log, P2 notes).
- The full suite found a fifth suite that asserted exit 1 for a restart line. The Test impact table had missed it (build log, P2).
- Pending migration 0009 had no human to confirm it, so the agent skipped it again (build log, P0 notes).

## Keep

- Run the baseline and the step suite side by side in clean clones while the agent writes evidence.
- Pin a failure case beside each new success path.

## Change

- Search for the old exit code beside the old line text when a P1 plan lists test impact.
- Record migration 0009 as done in the ledger so step sessions need no skip. Steps 50 and 52 asked for the same change.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Test impact search covers exit-code assertions | pack maintainers | `ravintio-zero/skills/ravintio-plan/SKILL.md` | the plan skill names the search | none yet, the coordinator decides whether to file it |
| Ledger row for migration 0009 | pack maintainers | `plan/state/migrations.md` | resume detection reports no pending migration | none, because the coordinator can add the row directly |
