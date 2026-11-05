---
title: "Backlog Entry: 0000350 - each step commit is titled with its feature title"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
priority: "high"
theme: "initiative-history"
---
# Backlog Entry: 0000350 - each step commit is titled with its feature title

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-11-01

---

## Problem

A step squash on an initiative branch takes its title from the step PR, in the form `{feature-id}-{slug}: {summary} (#{n})`. The summary is free text, so it often differs from the feature title. In initiative 0000312:

| Step commit | Feature title |
|-------------|---------------|
| `0000327-squash-before-main: check and squash PRs into main (#98)` | Squash before main |
| `0000321-backlog-triage: add backlog priority, index, and review (#96)` | Backlog triage |
| `0000316-hooks-fail-closed: run hooks from the project root, fail closed (#85)` | hooks fail closed |

Brief titles also vary in case, as the last row shows. The slug repeats the title. A reader can't match a commit to its feature at a glance, and `check-initiative-history.mjs` checks only the prefix form.

## Suggested Action

The human chose this form on 2026-11-01:

| Commit | Title |
|--------|-------|
| Step squash | `{feature-id}: {Feature title} (#{n})`, as in `0000327: Squash before main (#98)` |
| Chore commit (entry 0000345) | `{initiative-id}: Initiative admin (#{n})` |

1. Ship titles the step PR `{feature-id}: {Feature title}`, taking the title from the feature brief `title:` field in sentence case. The squash then carries it.
2. Add a `Title` column to the `## Steps` table in `initiative.template.md`. Chart fills it, and P0 uses it as the feature brief title.
3. `check-initiative-history.mjs` reads each step's title from that column and checks the step commit title matches it exactly.
4. Update the title rules in `ravintio-zero/standards/roadmap-standards.md` and `ravintio-zero/standards/commit-standards.md`, and the coordinator PR title form.

A test could build an initiative branch with one mistitled step and expect the check to fail.

## Why Deferred

The change edits ship, two standards, and the history script, so it needs its own step.
