---
title: "Backlog Entry: 0000518 - Ship removal of plan/current stops the step"
summary: "Ship Step 4 stops when the Claude Code safety check refuses to delete plan/current, and P2 tells the agent to write docs while the full suite runs."
status: "open"
priority: "medium"
theme: "ship-and-p2-process"
---
# Backlog Entry: 0000518 - Ship removal of plan/current stops the step

**Source feature:** 0000487-steps-apply-decision-rows

**Source phase:** P4

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-11

---

## Problem

Ship Step 4 tells the agent to delete the contents of `plan/current/`. The Claude Code safety check refused the removal, and the step stopped with a Blocked line until the coordinator ran `git rm -rq plan/current`. Separately, P2 tells the agent to write docs while the full suite runs, but the runner fails on a changed tree.

## Suggested Action

Change ship Step 4 to remove the folder with `git rm -r` after the copy, which the safety check accepts. Change the P2 text so the agent writes docs before the suite starts or after it ends.

## Added on 2026-11-11

The human made this step 58 of initiative 0000360. The stop cost about 2 hours, from 04:55 to 06:53, because the driver stayed stopped until the coordinator unblocked the step.

Ship Step 4 runs `git rm -r -q plan/current` from the repo root, with a literal path and no `cd` or glob. A test checks that the Ship skill names this command and names no `rm -r` of `plan/current/`.

## Why Deferred

Both changes edit pack skills, and ship must not edit pack files during the run.
