---
title: "Scope - driver setup stop"
summary: "Boundaries for the driver setup stop."
status: "active"
version: "0.41.0"
---
# Scope - driver setup stop

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000313-driver-setup-stop
**Version:** 0.41.0

## In Scope

- A `Setup:` stop in `ravintio-zero/scripts/initiative-run.mjs` for `ravintio-zero/skills/`, `ravintio-zero/hooks/`, `ravintio-zero/setup.sh`, and `ravintio-zero/setup/`.
- One combined line when `Restart:` also applies.
- The `Setup:` handling in the initiative skill.
- The `#### Setup stop` section in `roadmap-standards.md` and a line in `component.yml`.
- Tests for each, and an update to `test-0000250-req-002-driver-restart-stop.sh` AC-3.

## Out of Scope

- Changing any hook or `setup.sh`.
- Running setup from the driver.
- Watching `setup.ps1`.

## Deferred

- Hook resolution from a subfolder: blocked until step 4 (entries 0000287 and 0000288).
