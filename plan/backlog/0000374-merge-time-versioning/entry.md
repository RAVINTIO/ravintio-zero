---
title: "Backlog Entry: 0000374 - set each step's version when it merges"
summary: "A step bumps its version in P4, so two steps that run at once would compute the same version."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000374 - set each step's version when it merges

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-11-07

---

## Problem

In an initiative, P4 of each step reads the initiative branch's version, applies the step's `Bump`, edits the version files, writes the chart row's `Version` and `merged`, and moves `**Position:**`. The step tags its merge commit as `v{Version}`. This works only while one step runs at a time. Two steps cut from the same branch head would compute the same version and conflict on `initiative.md`.

`reshape-initiative.mjs` and `check-initiative-history.mjs` also expect the step commits in chart row order. Steps that run at once can merge in another order.

## Suggested Action

- Move the version work out of P4 into a serial merge queue in the driver. A step ends P4 with a green PR and no version change.
- The queue merges one ready PR at a time. Before each merge it rebases the PR on the initiative branch and waits for CI. Then it sets the version from the step's `Bump`, bumps every version file, merges, tags the merge commit, and writes the chart row's `Version` and `merged`.
- `reshape-initiative.mjs` and `check-initiative-history.mjs` follow merge order, read from the step tags, not chart row order.

## Wanted outcome

Each step's version and tag reflect the order in which steps merge. Tests check these conditions:

- Two fixture steps that merge in reverse chart order get consecutive versions in merge order, and each tag points at its step's merge commit.
- No step's P4 edits a version file or the chart's `Version` column.
- The reshape and the history check pass on a branch whose steps merged out of chart order.

## Why Deferred

The human asked for concurrent steps on 2026-11-07. Steps that run at once need this first.
