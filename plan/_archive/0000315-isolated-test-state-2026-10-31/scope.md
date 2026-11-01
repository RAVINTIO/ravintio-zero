---
title: "Scope - isolated test state"
summary: "Boundaries for the test isolation work."
status: "active"
version: "0.41.2"
---
# Scope - isolated test state

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000315-isolated-test-state
**Version:** 0.41.2

## In Scope

- Both runners clear every `RAVINTIO_*` variable before each suite, except `RAVINTIO_PWSH`, `RAVINTIO_TIMING_FILE`, and `RAVINTIO_TEST_QUIET`.
- A check that no suite writes the real `.next-id`, `plan/`, or `.claude/`.
- A final runner check on tracked and untracked files.
- `test-0000164-req-007` reads `hook-enforcement.md` and no longer reads `CLAUDE.md`.

## Out of Scope

- Comparing ignored files.
- Other flaky tests.
- Hook and skill changes.

## Deferred

- Nothing deferred.
