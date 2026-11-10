---
title: "Scope - 0000452-ci-wait-before-archive"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "draft"
version: "0.1.0"
---
# Scope - 0000452-ci-wait-before-archive

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000452-ci-wait-before-archive
**Version:** 0.1.0

## In Scope

- The initiative-step ship sequence in `ravintio-ship` and the I-D Advance stage of the roadmap standards.
- A rule that the step writes `ready` only when every check on the PR head passed.
- Tests in `src/ravintio-zero/tests/` for both requirements.
- Edits to the tests that pin the old order.
- A refresh of the installed copy with `sync-installed.mjs`.

## Out of Scope

- A reopen route that restores an archived run.
- Any change to `gate-write`, `merge-guard`, the driver, or the merge queue.
- A normal run outside an initiative. The human reviews that PR, and it keeps its order.
- Latency, availability, and scalability targets. The design defers them and sets none.

## Deferred

- Nothing deferred.
