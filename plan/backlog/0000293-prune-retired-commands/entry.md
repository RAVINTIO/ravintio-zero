---
title: "Backlog Entry: 0000293 - setup removes retired slash commands"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000293 - setup removes retired slash commands

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

`.claude/commands/` still holds `fast-path.md`, `change-pipeline.md`, and `retrofit.md`. The pipeline now has one route, and these commands are retired.

`fast-path.md` says it "Bypasses the full pipeline". A developer who runs it gets instructions that contradict the confirmed-design rule. Setup prunes retired skills (`setup.sh:1012`) but not retired commands.

## Suggested Action

- Prune any file in `.claude/commands/` that the pack shipped before and no longer ships. Track pack commands in the manifest so a developer's own commands stay.
- Make the same change in `setup.ps1`.
- Add a migration that removes the three retired commands from existing installs.

## Wanted outcome

An install holds only the commands the pack ships, plus the developer's own. Tests check these conditions:

- After setup, `.claude/commands/` has no `fast-path.md`, `change-pipeline.md`, or `retrofit.md`.
- A developer's own command file survives a re-run.

## Why Deferred

The human asked for it on 2026-10-31, from a review of how developers use Zero in their own repos. No run is active.
