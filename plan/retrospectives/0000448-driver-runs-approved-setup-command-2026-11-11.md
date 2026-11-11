---
title: "Retrospective: 2026-11-11 - Driver runs the approved setup command"
summary: "A blameless review of the approved setup command run, and the change it files."
status: "open"
---
# Retrospective: 2026-11-11 - Driver runs the approved setup command

**Mode:** run
**Subject:** 0000448-driver-runs-approved-setup-command
**Date:** 2026-11-11

## Summary

The run added `setup-command.mjs` and made the driver run the approved setup command at a `Setup:` stop. P0 to P2 took about 8 minutes. P3 took 18 minutes, mostly the sharded suite.

## What helped

- The archived run of step 40 gave a template for every artifact (`plan/_archive/0000472-ci-duration-metric-2026-11-10/`).
- The shared scheduler fixture ran the concurrent path with a one-line switch, `QUEUE_SETUP_STEP` (`src/ravintio-zero/tests/helpers/scheduler-fixture.sh`).
- The chart decision row for steps 25 to 41 named four shards and the two inherited failures, so P3 needed no base run (`plan/current-initiative/initiative.md`).

## What slowed the work

- The `gate-write` hook rejected the first writes until the sentinel and design existed, so two commands ran twice (build log P0 note).
- `prose-check` rejected three commits for sentences over 24 words in plan files. Each needed an edit and a rerun.
- Resume detection reported pending migration 0009, which a step session cannot answer (build log P0 note).

## Keep

- The helper accepts one command form and the driver uses no shell. A later step can widen the form only with a separate approval (ADR 0310).

## Change

- Resume detection should not ask a step session to run a migration that needs a human answer (backlog entry 0000513).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Skip a human-gated, safe-to-skip migration in a step session | orchestrator skill | `src/ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-resume-detection.md` | A suite that plants a pending migration in a step session | `plan/backlog/0000513-pending-migration-noise-in-step-sessions/entry.md` |
