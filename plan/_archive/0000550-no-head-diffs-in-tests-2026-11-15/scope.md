---
title: "Scope - 0000550-no-head-diffs-in-tests"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - 0000550-no-head-diffs-in-tests

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000550-no-head-diffs-in-tests
**Version:** 0.125.0

## In Scope

- A rule in `testing-standards.md` that bans diffing against `HEAD` or a moving ref.
- A suite that scans `ravintio-zero/tests/` for such a diff, with a planted failing case.

## Out of Scope

- Suites that pass `--base HEAD` to a script, which is not a git diff of the repo under test.
- Checks for `git log` or `git show` against `HEAD`.

## Deferred

- Nothing deferred.
