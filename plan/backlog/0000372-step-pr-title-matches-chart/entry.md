---
title: "Backlog Entry: 0000372 - check a step PR title against the chart before the merge"
summary: "Steps 5 to 8 of initiative 0000349 squashed with the slug in the title, and only the delivery history check caught it."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000372 - check a step PR title against the chart before the merge

**Source feature:** 0000349-clean-initiative-history
**Source phase:** I-E Delivery
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-07

---

## Problem

`## Commit titles` in `ravintio-zero/standards/roadmap-standards.md` sets a step squash title of `{feature-id}: {Feature title} (#{n})`, with the 7-digit id. Steps 1 to 4 of initiative 0000349 matched it, for example `3b0dd33c 0000354: Steps run to the end (#114)`. Steps 5 to 8 squashed as `{id}-{slug}: {Title}`, for example `f6a11a71 0000355-codeql-and-branch-cleanup: CodeQL and branch cleanup in CI (#115)`.

`check-initiative-history.mjs` reported all four as missing step commits at delivery. The reshape rewrites the titles from the chart, so delivery recovers. Nothing checks the title while the step runs.

Source retrospective: `plan/retrospectives/0000349-clean-initiative-history-initiative-2026-11-07.md`.

## Suggested Action

1. Before `gh pr merge --squash`, compare the PR title with the `{feature-id}: {Title}` form from the chart's `## Steps` row, and stop on a mismatch.
2. Add a test with a step PR title that holds the slug.

## Why Deferred

Found at I-E Delivery, after every step had merged.
