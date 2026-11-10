---
title: "Scope - Tests catch runner-only failures"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Tests catch runner-only failures

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000462-tests-without-git-identity
**Version:** 0.80.1

## In Scope

- `helpers/git-isolation.sh`, called by `run-tests.sh`, and the same isolation in `run-tests.ps1`.
- Identity fixes in each suite that the isolation exposes.
- A BOM suite for `doctor`, `setup.sh`, and `setup.ps1`, and a fix to any reader that fails.
- ADR-0301, docs, and a changelog entry.
- The sync of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- Other differences between local and CI runs, such as the OS and the shell.
- Changes to the CI workflow.

## Deferred

Nothing deferred.
