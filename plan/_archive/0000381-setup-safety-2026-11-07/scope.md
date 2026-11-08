---
title: "Scope - Setup safety"
summary: "Boundaries of what step 5 delivers."
status: "active"
version: "0.1.0"
---
# Scope - Setup safety

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000381-setup-safety
**Version:** 0.60.0

## In Scope

- A relative `.ravintio-manifest` and a confinement check in `setup.sh` and `setup.ps1`
- A test that lists `.claude/skills/` before and after the full run
- Whole-folder copy of capability skills
- First-install preservation of a developer `CLAUDE.md`
- A command manifest, a retired-command prune, and migration 0008
- Docs for each change in `project-operations.md`

## Out of Scope

- The `--uninstall` flag and strict-mode persistence (step 6)
- A package-level update command (step 6)
- Codex boot file handling beyond the shared `write_boot_file` path

## Deferred

- Nothing.
