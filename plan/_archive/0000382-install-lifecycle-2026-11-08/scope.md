---
title: "Scope - Install lifecycle"
summary: "Boundaries of what step 6 delivers."
status: "active"
version: "0.1.0"
---
# Scope - Install lifecycle

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Version:** 0.61.0

## In Scope

- `--doctor`, `--update`, and `--uninstall` in `setup.sh` and `setup.ps1`
- The clean-tree and git-repo check, and a test helper that commits the pack in each workspace
- Strict mode that follows the flags, and `--no-strict-orchestrator`
- `--help`, the banner fix, and next-step wording in hook block messages
- Getting-started sections for joining, day-to-day commands, and override skills
- A session-start check for unwired hooks
- `pack-facts.mjs`, the committed facts file, and the CI check
- Docs for each change in `project-operations.md`

## Out of Scope

- Download of a release over the network
- Moving the pack source to `src/` (step 20)

## Deferred

- Nothing.
