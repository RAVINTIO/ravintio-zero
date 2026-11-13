---
title: "Backlog Entry: 0000424 - A helper writes and checks the ready file"
summary: "A helper writes and checks the ready file, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000424 - A helper writes and checks the ready file

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

A step writes `$RAVINTIO_INITIATIVE_CONTROL/ready` by hand. Step 9 wrote a timestamp and step 20 left the file empty. The driver stops on any value that is not a PR number. The standard describes the file in prose and the pack ships no helper.

Evidence rows: 9 and 10. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Add a helper such as `initiative-ready.mjs --pr {n}` that checks the PR number and writes the file. Let the driver recover the number from the step branch if the file is bad.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
