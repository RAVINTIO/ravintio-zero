---
title: "Scope - initiative history checks"
summary: "Boundaries for the history checks."
status: "active"
version: "0.45.0"
---
# Scope - initiative history checks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000319-initiative-history-checks
**Version:** 0.45.0

## In Scope

- `check-initiative-history.mjs` and `check-main-merge.mjs`.
- The `push` trigger, the history job, the main check, and the `release-tag` guard in both workflow copies.
- I-E Delivery text in the standards and the initiative skill.
- A doc that names the `main` ruleset.
- Tests, docs, version, and changelog.

## Out of Scope

- Applying the GitHub ruleset. The human applies it.
- Hook changes.
- Any exception list in the history script.

## Deferred

- The driver or the initiative skill reporting a failed CI run on the initiative branch before the next step. Blocked until the driver can read CI state.
