---
title: "Backlog Entry: 0000543 - Delivery PR lists steps in version order"
summary: "The initiative PR body listed steps in chart order, so the version column jumped about."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000543 - Delivery PR lists steps in version order

**Source feature:** 0000360-backlog-sweep
**Source phase:** I-E Delivery
**Deferral source:** human request, 2026-11-13
**Date filed:** 2026-11-13

---

## Problem

The first body of initiative PR #202 listed the 61 steps in chart order. Concurrent steps merge in ready order, so the `Version` column ran out of order. For example, step 6 has v0.63.0 and step 7 has v0.62.0. The branch holds the steps in version order, so the table did not match the history the human reviews.

The coordinator built the table by hand from the `## Steps` table of the chart. Rule 6 of I-E Delivery in `roadmap-standards.md` says to list each step with its version and tag. It names no order, and no script builds the table.

The coordinator re-sorted the table by version and updated the body on 2026-11-13.

## Suggested Action

- State in I-E Delivery rule 6 that the table lists steps in ascending `Version` order, which is merge order.
- Make `reshape-initiative.mjs` print the step table in replay order, with step, title, version, and tag. The coordinator pastes it into the PR body.
- Add a test that the printed table is in ascending version order for a chart whose versions are out of chart order.

## Why Deferred

Found by the human while reviewing PR #202, after I-E Delivery ended.
