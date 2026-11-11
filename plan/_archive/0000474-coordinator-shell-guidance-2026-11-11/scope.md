---
title: "Scope - Coordinator shell guidance"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.98.0"
---
# Scope - Coordinator shell guidance

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000474-coordinator-shell-guidance
**Version:** 0.98.0

## In Scope

- A section `### Coordinator shell tasks` in `roadmap-standards.md`. It names bash and says to write scripts with the Write tool.
- A short pointer in the initiative skill.
- A `drain` subcommand in `initiative-queue.mjs` that removes the items naming a merged step.
- A script `bulk-edit.mjs` that applies literal edits from a JSON spec file.
- The overlap check stays in `coordinator-pr-check.mjs`. The section names it with its exact command.
- A test that the two guards still block variable, compound, and quoted commands.
- The edits live in `src/ravintio-zero/`. The sync script refreshes the installed copies in its own commit.

## Out of Scope

- Any change to `merge-guard` or `block-forced-add`.
- A new overlap script. `coordinator-pr-check.mjs` already prints `overlap:` lines.
- Step sessions. They never touch the queue (hard limit 5 of the initiative skill).

## Deferred

Nothing deferred.
