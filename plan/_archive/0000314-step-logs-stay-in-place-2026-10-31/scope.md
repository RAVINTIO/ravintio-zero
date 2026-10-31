---
title: "Scope - step logs stay in place"
summary: "Boundaries for the step log fix."
status: "active"
version: "0.41.1"
---
# Scope - step logs stay in place

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000314-step-logs-stay-in-place
**Version:** 0.41.1

## In Scope

- Skip `plan/.initiative-logs` in the phase guard of `test-0000042-req-006-phase-guard-and-stale-cites.sh`.
- A rule in the orchestrator skill, the initiative skill, and `roadmap-standards.md`: a step session never moves, renames, or deletes `plan/.initiative-logs/`, `plan/.initiative-runner.lock`, or `plan/.initiative-queue/`.
- Tests for the guard, the rule text, and the full run.

## Out of Scope

- Scanning tracked files only.
- Isolating other session state from the suite (step 3).
- A hook that blocks moves of driver files.

## Deferred

- Nothing deferred.
