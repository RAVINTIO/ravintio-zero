---
title: "Backlog Entry: 0000365 - the forced-add guard blocks shell text that only names the command"
summary: "A shell heredoc or script that holds the words of a forced add is blocked, even when it only writes test or edit text."
status: "open"
priority: "low"
theme: "guards"
---
# Backlog Entry: 0000365 - the forced-add guard blocks shell text that only names the command

**Source feature:** 0000357-guard-gaps-closed
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-06

---

## Problem

`block-forced-add.mjs` reads the words of a Bash command. A heredoc that writes a test file, or a Python edit script, that holds the words `git add -f` is blocked, though it only writes text. Step 6 of initiative 0000349 lost several tool calls to this and moved the text into the Write and Edit tools or into a script file.

Source retrospective: `plan/retrospectives/0000357-guard-gaps-closed-2026-11-06.md`.

## Suggested Action

Skip the text of a heredoc body and of a quoted argument to `cat`, `echo`, and `printf` when the guard reads a segment, and add a test for each. Weigh it against the widened rules, which the chart says to keep tight.

## Why Deferred

Loosening a guard needs its own design and tests. This step only closes gaps.
