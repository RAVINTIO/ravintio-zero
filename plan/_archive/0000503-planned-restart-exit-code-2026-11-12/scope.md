---
title: "Scope - Planned restart exits with its own code"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.108.0"
---
# Scope - Planned restart exits with its own code

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000503-planned-restart-exit-code
**Version:** 0.108.0

## In Scope

- A `planned` flag on the driver stop. A stop line that starts `I-D Advance: Restart:` sets it.
- `main()` in `initiative-run.mjs` exits 75 for a planned stop and 1 for every other stop.
- A restart hit that shares a run with a failure exits 1.
- Tests in `src/ravintio-zero/tests/`. They update the fixtures that expect exit 1 on a restart line.
- The driver header comment, `roadmap-standards.md`, and the initiative skill state the code.
- ADR-0327 records the decision. `docs/decisions-index.md` lists it.
- A refresh of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- The `Setup:` stop without a restart. It keeps exit 1.
- The handoff, where the old driver exits 0.
- The watcher, which reads the lock and never sees the exit code.
- Any hook guard.

## Deferred

Nothing deferred.
