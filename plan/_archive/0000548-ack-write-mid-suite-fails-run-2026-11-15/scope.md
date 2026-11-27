---
title: "Scope - 0000548-ack-write-mid-suite-fails-run"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.115.0"
---
# Scope - 0000548-ack-write-mid-suite-fails-run

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000548-ack-write-mid-suite-fails-run
**Version:** 0.115.0

## In Scope

- A git-ignored marker `plan/.suite-running` that both runners write and remove.
- A quiet strict hook for a step session while the marker names a live pid.
- A suite for both parts, docs, and ADR 0344.

## Out of Scope

- Any exemption of `plan/.orchestrator-ack` from the tree check. The chart forbids it.
- The coordinator banner and advisory mode.

## Deferred

Nothing deferred.
