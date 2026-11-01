---
title: "Backlog Entry: 0000333 - dispatch template omits the commit subject limit and the living docs unit"
summary: "Subagents hit the 72-character commit subject limit by trial, and ship wrote the living docs that P2 should have written."
status: "open"
---
# Backlog Entry: 0000333 - dispatch template omits the commit subject limit and the living docs unit

**Source feature:** 0000318-titled-coordinator-prs
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01

---

## Problem

In step 6, all three P2 subagents wrote a commit subject over 72 characters. The `commit-msg` hook rejected each one and the agent shortened it. The agent dispatch template in `ravintio-zero/standards/agent-dispatch-standards.md` does not state the limit. The execution plan also had no unit for the living docs, so ship edited `docs/architecture-overview.md` and `docs/decisions-index.md` after P3. Source: retrospective `plan/retrospectives/0000318-titled-coordinator-prs-2026-11-01.md`.

## Suggested Action

Add the 72-character subject limit to the dispatch template. Add a living-docs unit to the plan skill's Concurrency plan guidance, and check it in `consistency-check.mjs`.

## Why Deferred

The fix edits the plan skill and a script. It needs its own design.
