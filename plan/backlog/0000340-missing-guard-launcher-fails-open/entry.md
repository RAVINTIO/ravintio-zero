---
title: "Backlog Entry: 0000340 - a missing guard launcher lets the call through"
summary: "A coordinator-observed gap, filed for pickup at a future discovery run."
status: "open"
priority: "high"
theme: "guards"
---
# Backlog Entry: 0000340 - a missing guard launcher lets the call through

**Source feature:** none (initiative 0000312 supervision)
**Source phase:** none (initiative 0000312 supervision)
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01

---

## Problem

Every guard hook runs through `.claude/hooks/enforcement/guard-run.mjs`. If that file is missing, the hook command exits 1. Claude Code treats exit 1 as a non-blocking error and allows the call, so every guard fails open at once.

Step 4 of initiative 0000312 (feature 0000316) rated this medium in its security report and left it unmitigated in code. Today only the hook check at each setup stop catches it.

Source retrospective: `plan/retrospectives/0000312-guards-history-and-test-noise-initiative-2026-11-01.md`.

## Suggested Action

Make a missing launcher block the call, for example with a wrapper command that exits 2 when the launcher is absent. Add a test that removes the launcher and expects a block.

## Why Deferred

Step 4 scoped its fix to project-root resolution. This change needs its own design for how a hook command fails closed with no script to run.
