---
title: "Scope - 0000399-smoother-activation"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "draft"
version: "0.1.0"
---
# Scope - 0000399-smoother-activation

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Version:** 0.1.0

## In Scope

- Items 1 to 7 of backlog entry 0000398.
- New scripts `initiative-activate.mjs`, `initiative-add-step.mjs`, and `coordinator-pr-check.mjs` in `src/ravintio-zero/scripts/`.
- Edits to the initiative skill, `resume-detect.mjs`, `auto-trigger-orchestrator.mjs`, `check-orchestrator-presence.mjs`, and `roadmap-standards.md`.
- Tests in `src/ravintio-zero/tests/` for each requirement.
- A refresh of the installed copy with `sync-installed.mjs`.

## Out of Scope

- A faster full suite.
- Changes to the driver or the merge queue.
- Pending migration 0009 in step sessions. Backlog entry 0000403 covers it.
- Starting the driver or watcher from the activate script.
- Latency, availability, and scalability targets. The design defers them and sets none.

## Deferred

- Nothing deferred.
