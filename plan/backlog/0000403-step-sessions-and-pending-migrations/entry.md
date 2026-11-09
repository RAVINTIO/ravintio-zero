---
title: "Backlog Entry: 0000403 - step sessions meet pending migrations"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000403 - step sessions meet pending migrations

**Source feature:** 0000381-setup-safety
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-07

---

## Problem

Migration 0008 detects the retired commands in `.claude/commands/`. The main checkout holds them, and each step worktree copies that folder. Resume detection reports `pending migration: 0008` in every later step session. Migrations 0004 and 0005 already show as pending although the ledger holds `not applicable` rows for them.

A step session has no human to answer the migrator's `Proceed? (y/n)`.

## Suggested Action

- Make `resume-detect.mjs` skip a migration whose ledger row exists.
- State in the orchestrator resume check what a step session does with a pending migration whose helper needs no input.

## Wanted outcome

A step session never stops on a migration it cannot run. A test plants a ledger row and a Detect match, and expects no pending line.

## Why Deferred

Step 5 changes setup, not resume detection. Retrospective: `plan/retrospectives/0000381-setup-safety-2026-11-07.md`.
