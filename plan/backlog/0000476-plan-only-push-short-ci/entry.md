---
title: "Backlog Entry: 0000476 - run a short CI path on a plan-only push"
summary: "The closing archive push of a step changes only plan/ files and the sentinels, yet CI reruns every suite."
status: "open"
priority: "medium"
theme: "ci"
---
# Backlog Entry: 0000476 - run a short CI path on a plan-only push

**Source feature:** 0000452-ci-wait-before-archive
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-10

---

## Problem

An initiative step now ends with a closing push that archives `plan/current/` and clears the sentinels. That push changes only files under `plan/`. CI still reruns every suite, and the step waits for it before `ready`.

Source retrospective: `plan/retrospectives/0000452-ci-wait-before-archive-2026-11-10.md`.

## Suggested Action

Make the workflow run the plan format checks and skip the shard suites when every changed file since the last green run is under `plan/`. A guard must not pass a form it blocks today.

## Wanted outcome

- A workflow test shows a plan-only push skips the suites.
- A test shows a push that changes any file outside `plan/` still runs them.

## Why Deferred

It changes the CI workflow, which is outside step 30.
