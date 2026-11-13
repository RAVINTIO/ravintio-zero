---
title: "Backlog Entry: 0000484 - Check mergeability before a CI wait"
summary: "PR #166 for step 36 conflicted with the initiative branch after other steps merged."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000484 - Check mergeability before a CI wait

**Source feature:** 0000483-mergeability-before-ci-wait
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-10
**Date filed:** 2026-11-10

---

## Problem

PR #166 for step 36 conflicted with the initiative branch after other steps merged. GitHub runs no pull request workflows on a PR that conflicts, so no check ever registered. Step 36 waited on checks that could never arrive, from 20:07 to 21:16 on 2026-11-10. The merge queue can wait the same way.

Evidence row: 28 in `plan/current-initiative/coordinator-evidence.md`.

## Suggested Action

Before a CI wait, the step and the queue read `gh pr view --json mergeable`. If the PR conflicts, they merge the initiative branch first and do not wait. A wait that sees no checks after a set time stops with a named error.

## Why Deferred

Found during I-C Run of initiative 0000360, after the step 22 retrospective. The human asked for it as its own step.
