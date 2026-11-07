---
title: "Scope - Clean step stops and logs"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Clean step stops and logs

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000358-clean-step-stops-and-logs
**Version:** 0.55.0

## In Scope

- `Question` in the status set of the orchestrator, `pipeline-reference.md`, both boot templates, and the `check-reply-prefix.mjs` comment.
- `Question:` on the product id check line.
- The clock command in five phase skills.
- Two `build-log-check.mjs` checks: a future time and a closed block with no `Complete:` line.
- The failed suite list in `run-tests.sh` and `run-tests.ps1`, and a pointer in the validate skill.
- Tests for each.

## Out of Scope

- Resume detection and governance counts. They keep reading `Blocked:`.
- A change to the prefix hook logic. It warns only.
- Rewriting existing archived build logs.

## Deferred

Nothing deferred.
