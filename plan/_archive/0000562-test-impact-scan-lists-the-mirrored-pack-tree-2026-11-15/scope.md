---
title: "Scope - Test impact scan lists the mirrored pack tree"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Test impact scan lists the mirrored pack tree

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000562-test-impact-scan-lists-the-mirrored-pack-tree
**Version:** 0.115.0

## In Scope

- A reference file for the scan causes, with a `## Pack Index` row.
- A `Pack file edit` cause.
- A P0 rule for `## Component Paths`.
- Pin updates in three suites, and one new suite.

## Out of Scope

- Causes that steps 19 to 27 add.
- Hook and script changes.

## Deferred

- Nothing deferred.
