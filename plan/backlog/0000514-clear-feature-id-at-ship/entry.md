---
title: "Backlog Entry: 0000514 - Ship leaves plan/.feature-id behind"
summary: "plan/.feature-id stays tracked after a step ships, so the next step starts with a stale id and the base merge conflicts on it."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000514 - Ship leaves plan/.feature-id behind

**Source feature:** 0000483-mergeability-before-ci-wait

**Source phase:** P4

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-11

---

## Problem

Ship Step 8 clears `plan/.orchestrator-active`, `plan/.orchestrator-ack`, `plan/.run-mode`, and `plan/.run-speed`. It leaves `plan/.feature-id`. Each squash carries the last step's id onto the initiative branch. Step 43 started with `0000446-drain-ready-prs-after-a-stop` there. Its base merge then conflicted on the file, because step 28 had written `0000448-driver-runs-approved-setup-command`. Resume detection flags the stale id each time.

## Suggested Action

Make ship Step 8 delete `plan/.feature-id` for an initiative step, or add the file to the shared files that `shared-files.mjs` resolves. A test checks that no step branch carries the file after the closing push.

## Why Deferred

It is outside the scope of step 43. It needs its own design decision on which fix to take.
