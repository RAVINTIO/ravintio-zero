---
title: "Scope - titled coordinator PRs"
summary: "Boundaries for the coordinator PR work."
status: "active"
version: "0.44.0"
---
# Scope - titled coordinator PRs

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000318-titled-coordinator-prs
**Version:** 0.44.0

## In Scope

- A rule in `roadmap-standards.md` that nothing commits directly on `initiative/*`.
- A coordinator PR section: title form, local suite, green CI, and the agent squash.
- The merge carve-out names coordinator PRs and keeps its current conditions.
- Initiative skill text for queued entries, scope edits, activation, and delivery.
- Ship skill text that records the PR number before the squash.
- A test that pins `merge-guard` behaviour.
- Docs and the version record.

## Out of Scope

- Any change to `merge-guard.mjs`.
- The history script and its CI check (step 7).
- The initiative PR to `main`, which stays human-only.

## Deferred

- Nothing deferred.
