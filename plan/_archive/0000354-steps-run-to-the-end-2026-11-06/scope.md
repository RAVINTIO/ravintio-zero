---
title: "Scope - Steps run to the end"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Steps run to the end

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0

## In Scope

- Driver resume of a step that exits 0 unmerged, capped at two resumes.
- The early-end rule in the orchestrator skill.
- Setup leaves the tracked record unchanged when only `writtenAt` would change, in `setup.sh` and `setup.ps1`.
- One test helper for the driver arguments.
- The watcher wait for the build log and the running step name.
- The `**Step CI fixes:**` chart field and its rule in the standards.
- Tests for each rule.

## Out of Scope

- CodeQL and branch cleanup (step 5).
- Any change to `merge-guard` or another fail-closed hook.
- A change to the first driver prompt `Run initiative step {n}`.

## Deferred

- None. Entries 0000334, 0000343, 0000256, 0000270, and 0000344 are complete once this step ships.
