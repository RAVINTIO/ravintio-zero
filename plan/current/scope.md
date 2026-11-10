---
title: "Scope - plan rereads files at the branch point"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - plan rereads files at the branch point

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000470-plan-rereads-files-at-the-branch-point
**Version:** 0.83.0

## In Scope

- A `## Branch-point reread` section in the plan skill.
- A `## Branch-point reads` table in the execution plan template.
- A new suite, ADR-0306, docs, and a changelog entry.
- The sync of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- A script that automates the reread.
- A hook that blocks a plan with a stale read.
- A reread in P2 before each edit.

## Deferred

Nothing deferred.
