---
title: "Backlog Entry: 0000582 - Delivery cleans up driver state"
summary: "Delivery cleans up driver state"
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000582 - Delivery cleans up driver state

**Source feature:** 0000581-delivery-cleans-up-driver-state
**Source phase:** I-B Activate
**Deferral source:** add-step helper
**Date filed:** 2026-11-14

---

## Problem

I-E Delivery leaves the driver state of the delivered initiative in `plan/`. Initiative 0000360 left `plan/.initiative-control/` with 17 `running` and `ready` files, and `plan/.initiative-logs/` with every step log.

The next initiative reuses step numbers. Its driver reads a stale `running` file as a step to resume, and the status script reports 16 running steps before any step starts. On 2026-11-14 the coordinator had to move both folders by hand before it could start the 0000544 driver.

## Wanted outcome

After the human merges the initiative PR, I-E Delivery cleans up the driver state of that initiative:

- It refuses while a driver holds `plan/.initiative-runner.lock`.
- It moves `plan/.initiative-logs/` and `plan/.initiative-control/` to `.git/ravintio-archive/{id}-{slug}/`, so the logs stay readable as stop evidence.
- It removes every worktree under `plan/.initiative-worktrees/` and prunes them with `git worktree prune`.
- It leaves `plan/.initiative-queue/` in place if an item remains, and reports each one.

The `ravintio-initiative` skill and the I-E Delivery section of the roadmap standards name the cleanup as a final report item. A test checks that a cleaned root gives `merged 0, ready 0, running 0` from `initiative-status.mjs` for a new chart.
