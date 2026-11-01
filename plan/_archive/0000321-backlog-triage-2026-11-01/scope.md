---
title: "Scope - Backlog triage"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Backlog triage

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000321-backlog-triage
**Version:** 0.47.0

## In Scope

- `priority` and `theme` in the backlog template and the filing skill.
- `backlog-index.mjs` with write, `--check`, and `--review` modes, and `plan/backlog/index.md`.
- A CI step in `.github/workflows/ravintio.yml` and `ravintio-zero/hooks/ravintio.yml`.
- Ordered pickup and the staleness review in Discovery Start Actions step 10.
- `backlogReviewDays` in `product.template.yml` and `product.yml`.
- Migration 0007, its helpers, and its application in this repo.
- Tests, docs, version 0.47.0, and the changelog.

## Out of Scope

- Choosing a real priority or theme for the existing entries.
- Closing or deleting a stale entry.
- Any hook that blocks.
- Close an entry that a later change made obsolete (gap: out of scope).

## Deferred

Nothing deferred.
