---
title: "Backlog Entry: 0000339 - a one-commit coordinator PR uses the titled commit subject"
summary: "A coordinator-observed gap, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "initiative-history"
---
# Backlog Entry: 0000339 - a one-commit coordinator PR uses the titled commit subject

**Source feature:** none (initiative 0000312 supervision)
**Source phase:** none (initiative 0000312 supervision)
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01

---

## Problem

`## Coordinator PRs` in `ravintio-zero/standards/roadmap-standards.md` sets the title form for the PR only. GitHub takes the squash title of a one-commit PR from the commit subject, not the PR title.

That is how `8c01e3d2 chore(setup): record the setup rerun after step 2 (#83)` reached the initiative 0000312 branch. `check-initiative-history.mjs` fails on it at I-E Delivery.

Source retrospective: `plan/retrospectives/0000312-guards-history-and-test-noise-initiative-2026-11-01.md`.

## Suggested Action

Add one sentence to `## Coordinator PRs`: in a one-commit PR, the commit subject uses the same `{id}-{slug}: {summary}` form. A test could check that the standard says so.

## Why Deferred

The initiative had delivered when the history check found the commit. The fix changes a standard and needs its own step.
