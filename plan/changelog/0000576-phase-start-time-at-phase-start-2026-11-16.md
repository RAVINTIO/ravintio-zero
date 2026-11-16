# Changelog (0000576-phase-start-time-at-phase-start, 16 Nov 2026)

**Feature:** Record each phase start time when the phase begins
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- Check 10 of `build-log-check.mjs` fails a phase block whose `Start` is later than the first commit of that phase's artifacts. The finding names the phase.
- The Phase Invocation reference holds the rule `phase-start-time-check`, which names the check.
- Two suites cover the check and the wiring. ADR 0351 records the decision.

## Why

An earlier run wrote the P1 to P3 blocks at phase end. Their wall clock read 0 minutes and the build report showed `not recorded`.

## Deviations

- The agent ran units U1 to U3 inline in one tree and dispatched no subagent, because each unit is small.
- Unit U3 (docs) has no executable check. Backlog 0000410 tracks the rule.
- P2 counts paths outside `plan/` and `docs/`, because the ADR counter lands at P1. The design and the requirement say so.

## Validation results

Filled at P3.

## Skipped phases

None.
