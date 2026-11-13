---
title: "Scope - Replies name actors by role"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Replies name actors by role

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000521-replies-name-actors-by-role
**Version:** 0.103.0

## In Scope

- The `Reply Conventions` section of `standard-boot.md` and `codex-boot.md`.
- The orchestrator skill reporting rule and the roadmap standards `Reply prefixes` section.
- The rule `actor-pronoun` in `check-reply-writing.mjs`.
- The initiative skill heading `Decisions for the human`, the roadmap standards line, and test 0000450.
- Two pin suites, one ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

## Out of Scope

- A blocking hook. The reply check stays advisory.
- Prose rules for documents and commit messages. `prose-rules.mjs` stays as it is.
- Rewording every "you" in the pack skills. Skills address the agent in second person.

## Deferred

Nothing deferred.
