---
title: "Scope - Replies and questions"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "draft"
version: "0.1.0"
---
# Scope - Replies and questions

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000388-replies-and-questions
**Version:** 0.1.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- `check-design.mjs` injects the local time as `hh:mm`.
- `check-reply-prefix.mjs` accepts a leading `hh:mm` and logs a miss for a time with no prefix.
- The new "Reply prefix check" warning, with the quoted reply and the session name.
- The coordinator skip while `plan/.initiative-runner.lock` exists (ADR-001).
- `initiative-run.mjs` and `initiative-watch.mjs` start every printed line with `hh:mm`.
- Reply Conventions text in `standard-boot.md`, `codex-boot.md`, the orchestrator skill, the initiative skill, and `roadmap-standards.md`.
- `hook-enforcement.md`, where it describes the prefix hook.
- The recommend-then-confirm agreement rule in `orchestrator-p0-coaching.md`, the initiative skill, and a pointer in each phase skill that asks for approval.
- The question rule in `orchestrator-discovery-coaching.md`.
- Rule anchors and tests for each new rule.

## Out of Scope

- `merge-guard`, `gate-write`, and any other fail-closed hook.
- A new skill, a skill count change, or a workflow edit.
- A new component, a data contract, or an API.
- The writing standard from 0000300.

## Deferred

- The question rule in the writing standard (entry 0000300). Blocked until step 13 creates that file.
- Latency, availability, and scalability targets. The design defers them and no runtime service exists.
