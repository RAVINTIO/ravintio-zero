---
title: "Scope - Session integrity and guards"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Session integrity and guards

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000393-session-integrity-and-guards
**Version:** 0.65.0

## In Scope

- Shell-write detection in `gate-write.mjs`, and its Bash wiring in both setup scripts.
- Option-value and brace-group handling in `block-forced-add.mjs`.
- The `plan/state/pack-version.md` record, the `resume-detect.mjs` change, and the policy and template text.
- `check-entry-wording.mjs` and its call from the filing skill.

## Out of Scope

- Shell writes by `cp`, `mv`, `dd`, or a script.
- Any change that lets a guard pass a form it blocks today.

## Deferred

Nothing deferred.
