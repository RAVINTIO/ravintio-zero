---
title: "Backlog Entry: 0000260 - test backlog prose at filing"
summary: "A backlog entry that breaks a wording test is only found when a step runs the suite."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000260 - test backlog prose at filing

**Source feature:** 0000242-size-cap-excludes-overrides
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-28

---

## Problem

Commit 05abbb9 filed `plan/backlog/0000257-timestamp-reply-prefixes/entry.md` with wording that `test-0000042-req-010` rejects. Step 4 of initiative 0000238 found the failure at P2 and stopped from 2026-10-28T08:00:51Z to 13:13:22Z. The source is the retrospective for 0000242.

## Suggested Action

Run the wording test over `plan/backlog/` entries in the filing skill or a pre-commit check, so the author fixes the text at filing.

## Why Deferred

It changes the filing flow, which is outside a size cap step.
