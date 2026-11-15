---
title: "Retrospective: 2026-11-15 - require unit reports"
summary: "A blameless review of the 0000573 run and the change it files."
status: "open"
---
# Retrospective: 2026-11-15 - require unit reports

> Path: `plan/retrospectives/0000573-require-unit-reports-2026-11-15.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000573-require-unit-reports
**Date:** 2026-11-15

## Summary

The run added the unit report rule and its test. The ship check stopped the run once, on a docs unit with no RED or GREEN line.

## What helped

- The ship check caught the missing marker before archive (`plan/_archive/0000573-require-unit-reports-2026-11-15/build-log.md`, P4 Blocked line).
- The clean-clone run separated 3 inherited failures from new ones (P3 block, `baseline-failures.md`).

## What slowed the work

- The loop rules give a docs unit no marker form, so P2 logged a Deviation and ship stopped (P2 Deviation line, P4 Blocked line).
- The P2 wall clock spans a long gap between the unit work and the full suite (build log, P2 block).

## Keep

- Keep the ship-time build log check. It found the gap without a human (P4 Blocked line).

## Change

- Define the RED and GREEN markers for a unit with no executable check (postmortem `plan/postmortems/2026-11-15-docs-unit-no-red-green-marker.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Define markers for a non-test unit | pack maintainer | `ravintio-zero/skills/ravintio-implement/` | `build-log-check.mjs` | backlog 0000410, which the postmortem also cites |
