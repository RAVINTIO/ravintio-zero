---
title: "Scope - Driver runs the approved setup command"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Driver runs the approved setup command

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000448-driver-runs-approved-setup-command
**Version:** 0.91.0

## In Scope

- A helper script, `setup-command.mjs`, that reads the `Confirmation:` row for setup and checks the command.
- A change to `initiative-run.mjs` so both driver paths run the command at a `Setup:` stop.
- Text in `roadmap-standards.md` and the initiative skill.
- Two new suites, ADR 0310, docs, and a changelog entry.
- The sync of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- A change to `setup.sh`, `setup.ps1`, or any hook.
- Any widening of a guard.
- A command other than the pack `setup.sh` with flag words.

## Deferred

- The hook check after setup stays with the coordinator. It blocks nothing until a later step moves it into the driver.
