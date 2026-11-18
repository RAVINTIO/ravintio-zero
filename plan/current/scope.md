---
title: "Scope - 0000583-step-temp-cleanup-after-merge"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - 0000583-step-temp-cleanup-after-merge

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Version:** 0.146.0

## In Scope

- `cleanStepTemp` in `initiative-run.mjs`, called after each merge and in the start sweep.
- Signal-safe traps in five suites and the git-isolation helper.
- Two new tests, one for each requirement.
- A rule line in `roadmap-standards.md` and an entry in the living docs.

## Out of Scope

- Removing entries that earlier runs leaked.
- PowerShell suites.

## Deferred

Nothing deferred.
