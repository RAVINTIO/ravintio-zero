---
title: "Backlog Entry: 0000435 - The plan rereads shared files at the branch point"
summary: "The plan rereads shared files at the branch point, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000435 - The plan rereads shared files at the branch point

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

A queue test fake matched the script as it stood before step 16 merged. The first run sat in the CI wait. The postmortem set the preventive action to "none". Parallel steps change shared scripts within minutes, so a plan that reads early reads stale text.

Evidence row: 21. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Add a step to the plan skill that rereads each file a unit edits at the branch point and notes the commit it read.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
