---
title: "Scope - Light discovery and audits"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Light discovery and audits

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000387-light-discovery-and-audits
**Version:** 0.67.0

## In Scope

- The light track reference, its Pack Index row, and the `Track` field in the discovery template.
- The commit grouping rule in the discovery records reference, Hard Limit 8, and the boot template.
- Two coaching rules in the P0 coaching reference.
- The audit re-run in `ravintio-plan` and the `Audit:` line in the build log template.

## Out of Scope

- Any hook, guard, or script change.
- A check that enforces the track marker.

## Deferred

Nothing deferred.
