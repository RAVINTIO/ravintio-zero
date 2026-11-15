---
title: "Backlog Entry: 0000588 - P0 start actions do not say to write design.md first and use root paths"
summary: "Step 20 lost two Bash calls to gate-write, which blocks P0 artifacts written before design.md or with a path relative to a changed folder."
status: "open"
priority: "low"
theme: "orchestrator"
---
# Backlog Entry: 0000588 - P0 start actions do not say to write design.md first and use root paths

**Source feature:** 0000564-test-impact-hook-pins
**Source phase:** P0 Discovery
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-15

---

## Problem

Step 20 wrote the P0 artifacts in one Bash command. `gate-write` blocked it, because `design.md` did not exist yet. A second command used `cd plan/current` and a bare file name. The hook read `discovery.md` as a path outside the design, and blocked it again.

## Suggested Action

Add one sentence to the P0 start actions. Write `design.md` in a call of its own before any other `plan/current/` artifact, and write each path from the repo root. A standards test checks the sentence.

## Why Deferred

The fix edits the orchestrator reference. It is outside the plan scan change in step 20.
