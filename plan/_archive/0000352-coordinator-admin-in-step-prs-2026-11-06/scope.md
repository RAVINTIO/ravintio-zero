---
title: "Scope - Coordinator admin in step PRs"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Coordinator admin in step PRs

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000352-coordinator-admin-in-step-prs
**Version:** 0.50.0

## In Scope

- `reserve-id.mjs` refuses `--commit` on a branch whose name starts with `initiative/`. It exits 1, commits nothing, and names the `feat/` route.
- A queue item contract: a folder in `plan/.initiative-queue/` whose `item.md` names the step and the destination path.
- The rule that the step commits the items that name it before P4 raises the PR.
- The rule that admin which fits no step lands through a `chore/` PR as it happens.
- `--delete-branch` in every coordinator squash instruction.
- The `feat/` route in the skills that call `reserve-id.mjs --commit`.
- Tests for each rule.

## Out of Scope

- The reshape script and the `-reshaped` branch (step 3).
- The `chore/*` force-push rule in the ship skill (step 3).
- Driver and watcher changes, including queue clearing by the driver (step 4).
- Any change to `merge-guard` or another fail-closed hook.

## Deferred

- Rule 3 of entry 0000345 (the reshape at I-E Delivery). Step 3 takes it, so the entry stays in the backlog until then.
