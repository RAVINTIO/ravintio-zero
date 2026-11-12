---
title: "Scope - Check every hook after setup"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "draft"
version: "0.1.0"
---
# Scope - Check every hook after setup

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000507-hook-check-after-setup
**Version:** 0.110.0

## In Scope

- `src/ravintio-zero/scripts/hook-check.mjs`, which runs every hook in `.claude/settings.json` with a fixed sample.
- A test for the script beside the other script tests.
- A driver change in `initiative-run.mjs` that runs the check after the approved setup command.
- Docs and `component.yml` updates for the new script.
- The refresh commit that copies the source to `ravintio-zero/`.

## Out of Scope

- Changing the behaviour of any hook.
- Checking hooks outside `.claude/settings.json`, such as git hooks.
- Repairing a failing hook. A person or agent does that.

## Deferred

Nothing deferred.
