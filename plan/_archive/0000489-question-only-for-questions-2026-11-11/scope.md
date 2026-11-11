---
title: "Scope - Steps use Question only for real questions"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Steps use Question only for real questions

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000489-question-only-for-questions
**Version:** 0.99.0

## In Scope

- The status text in the orchestrator `SKILL.md`, `pipeline-reference.md`, and `roadmap-standards.md`.
- A Question check in `check-reply-prefix.mjs`.
- Two test suites, one ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

## Out of Scope

- Driver changes. The driver still stops on every open `Question:` line.
- Any hook that blocks a turn.
- Deciding whether a question is real. The check tests for a question mark only.

## Deferred

Nothing deferred.
