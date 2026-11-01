---
title: "Scope - Squash before main"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Squash before main

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000327-squash-before-main
**Version:** 0.48.0

## In Scope

- `check-pr-into-main.mjs` and its tests.
- The `squash-before-main` job in `.github/workflows/ravintio.yml` and `ravintio-zero/hooks/ravintio.yml`.
- `## PRs into main` in the ship skill, and the pointer from Hard Limit 5.
- The three allowed prefixes in `roadmap-standards.md` and `docs/main-ruleset.md`.
- Discovery Start Actions step 2 cuts `hotfix/{feature-id}`.
- Docs, version 0.48.0, and the changelog.

## Out of Scope

- Any hook change, including a force-push block.
- Editing `CLAUDE.md` or `ravintio-overrides/instructions/custom-001-local-git-only.md`.
- Applying the GitHub ruleset.
- Block a force-push at the hook (gap: out of scope).

## Deferred

Nothing deferred.
