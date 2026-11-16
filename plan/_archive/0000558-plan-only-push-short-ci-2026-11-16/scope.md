---
title: "Scope - CI avoids extra runs on a plan-only push"
summary: "The boundaries of the concurrency change."
status: "active"
version: "0.139.0"
---
# Scope - CI avoids extra runs on a plan-only push

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000558-plan-only-push-short-ci
**Version:** 0.139.0

## In Scope

- A top-level `concurrency` block in `.github/workflows/ravintio.yml`.
- One new test suite for the block and for the absence of path filters.

## Out of Scope

- The consumer copy `hooks/ravintio.yml`, which needs a consumer migration.
- Skipping a suite or a job on a plan-only push.
- A path filter on any job.
- A change to the ship skill.

## Deferred

- A short CI path for a plan-only push. It stays blocked until the human lifts the chart row for step 14.
