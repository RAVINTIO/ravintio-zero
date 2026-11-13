---
title: "Scope - short subject for the queue's base merge"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - short subject for the queue's base merge

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000405-queue-merge-subject
**Version:** 0.62.0

## In Scope

- The `-m` subject on the base merge in `cmdRun` of `merge-queue.mjs`.
- One test: `test-0000405-req-001-short-base-merge-subject.sh`.
- A changelog entry. No version bump, because this PR is not a chart step.

## Out of Scope

- The other driver gaps from the 2026-11-08 postmortem. They go to the next initiative.
- Any change to the `commit-msg` hook, `merge-guard`, or `commit-standards.md`.

## Deferred

Nothing deferred.
