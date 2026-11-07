---
title: "Scope - Faster test runs"
summary: "Boundaries of what step 9 delivers."
status: "active"
version: "0.1.0"
---
# Scope - Faster test runs

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000385-faster-test-runs
**Version:** 0.61.0

## In Scope

- An affected-tests rule in `ravintio-implement` and `ravintio-refactor`, one full suite run before P2 completes, and a build-log `Tests run:` line
- `baseline-failures.mjs`, a P0 step that records base-commit failures, and a P3 comparison
- An inherited failures section in the build report
- `clean-clone-test.mjs` and the P3 step that runs it, with the failed-suites-first rerun
- Docs in `testing-standards.md`, the build-log template, `component.yml`, and the tests README

## Out of Scope

- Changes to how `run-tests.sh` picks suites
- PowerShell ports of the new scripts
- Anchors in the orchestrator `SKILL.md`

## Deferred

- Automatic mapping from a changed file to its tests for stacks other than this pack
