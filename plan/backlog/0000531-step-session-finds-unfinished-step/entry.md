---
title: "Backlog Entry: 0000531 - A step session finds an unfinished step"
summary: "A step session that ends after a queue item leaves no build log, so a resume cannot tell where the step stands."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000531 - A step session finds an unfinished step

**Source feature:** 0000509-clear-merged-ready-files
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-13

---

## Problem

The first session of step 56 filed the queue item and ended its turn. It wrote no build log and left no `plan/current/`. The resume session found one commit, no PR, and no record of a phase. Resume detection printed "step session" and "feature id file present" and nothing that named the missing P0. The agent worked out the state from `git log` and `gh pr list`. See the retrospective `plan/retrospectives/0000509-clear-merged-ready-files-2026-11-13.md`.

## Suggested Action

Add a resume-detect finding for a step session with no `plan/current/build-log.md` and no archive folder for the feature id. The finding says to start P0 and names the branch commits. A test pins the finding.

## Why Deferred

The step changes the driver. Resume detection needs its own design.
