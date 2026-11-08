---
title: "Backlog Entry: 0000403 - the merge queue waits for CI after its version push"
summary: "The merge queue merges a step PR only after CI passes on the version commit it pushed."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000403 - the merge queue waits for CI after its version push

**Source feature:** 0000360-backlog-sweep
**Source phase:** I-D Advance
**Deferral source:** human request
**Date filed:** 2026-11-07

---

## Problem

The merge queue stopped step 4 of initiative 0000360 twice:

1. On a title mismatch. The orchestrator wrote the PR title as `0000380-test-helpers-and-rule-anchors: Test helpers and rule anchors`. The queue wants `0000380: Test helpers and rule anchors`.
2. On `gh pr merge failed: GraphQL: Pull Request is not mergeable`. The queue pushed `chore(0000380): set version 0.60.0 for step 4` to PR #129 and then merged at once. CI had restarted on the new commit, so GitHub refused the merge.

Each stop halts the driver, and under the concurrent driver it also stops every other running step.

## Suggested Action

- After it pushes the version commit, the queue waits for every check on the new head to complete. It merges only when all of them pass. If one fails, it stops with the check name.
- The orchestrator writes the step PR title in the form the queue checks, `{first 7 digits of Feature id}: {Title}`. Point P4 at `merge-queue.mjs title` before it raises the PR.

## Wanted outcome

- A test with a stub `gh` shows the queue waiting for pending checks after its push, then merging.
- A test shows the queue stopping, with the check name, when a check fails after its push.
- A test shows P4 raising a PR whose title passes `merge-queue.mjs title`.

## Why Deferred

The human asked for the fix to go into step 16 during I-C Run of initiative 0000360. Step 5 did not take it in. Until it lands, the queue stopped steps 4 and 9 on a title mismatch, and the coordinator retitled each PR.
