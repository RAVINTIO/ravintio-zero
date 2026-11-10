---
title: "Backlog Entry: 0000430 - Regenerate shared files at merge"
summary: "Regenerate shared files at merge, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000430 - Regenerate shared files at merge

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

Every merge edits `architecture-overview.md`, `decisions-index.md`, `plan/backlog/index.md`, `plan/backlog/.next-id`, or `docs/adr/.next-id`. Every other open PR then conflicts. Initiative 0000360 had about six rounds at about an hour each. No script generates `decisions-index.md` or `architecture-overview.md`, and no merge rule covers them. A coordinator PR also lacks an overlap check against open step PRs.

Evidence rows: 6 and 12. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Regenerate the index files in the queue after the base merge. Add a merge rule for the counter files. Add an overlap check to `coordinator-pr-check.mjs`.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
