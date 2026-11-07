---
title: "Backlog Entry: 0000364 - Check human-only settings before P3"
summary: "A step that needs a repo setting change finds the blocker at P3. A check at P1 would stop it earlier."
status: "open"
priority: "medium"
theme: "initiative-steps"
---
# Backlog Entry: 0000364 - Check human-only settings before P3

**Source feature:** 0000355-codeql-and-branch-cleanup
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-06

---

## Problem

Step 5 of initiative 0000349 needed the human to turn off CodeQL default setup. The chart row said so, but the step found the setting still on only at P3 (`Blocked:` line in the archived build log). The step wrote all its code first and then waited.

## Suggested Action

At P1, read the chart row for a human-only setting, check it with `gh api`, and print the `Blocked:` line before P2 if it is still wrong.

## Why Deferred

The check needs its own design decision on which settings the plan skill can read. See `plan/retrospectives/0000355-codeql-and-branch-cleanup-2026-11-06.md`.
