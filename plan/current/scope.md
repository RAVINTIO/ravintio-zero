---
title: "Scope - Reply times match the clock"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Reply times match the clock

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000499-reply-times-match-clock
**Version:** 0.101.0

## In Scope

- A `PostToolUse` hook, `clock-context.mjs`, that returns the local time.
- Setup wiring in `setup.sh` and `setup.ps1`, plus the hook lists in `install-lifecycle.mjs` and `pack-facts.json`.
- Clock rule text in `roadmap-standards.md`, the initiative `SKILL.md`, and `pipeline-reference.md`.
- A 2 minute margin and a status check in `check-reply-prefix.mjs`.
- A time stamp on each activity line of `initiative-watch.mjs`.
- Four test suites, one ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

## Out of Scope

- Any hook that blocks a turn or a tool call.
- Stamping lines other than watcher activity lines.
- The Codex install. It wires only `merge-guard` and `block-forced-add`.

## Deferred

Nothing deferred.
