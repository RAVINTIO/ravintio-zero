---
title: "Backlog Entry: 0000296 - P3 runs the suite in a clean clone"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000296 - P3 runs the suite in a clean clone

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

P3 runs the suite in the working tree, while CI runs it in a fresh checkout. Seven records found failures that came only from local state or the local OS. Untracked files, ignored caches, and OS differences let a local run pass when CI would fail, or fail when CI would pass.

## Suggested Action

- At P3, clone `HEAD` into a temporary folder and run the suite there.
- Compare the local OS with the CI OS from the workflow file, and name any gap in the build log.
- Remove the temporary clone when the run ends.

## Wanted outcome

P3's result matches CI for committed code. Tests check these conditions:

- The validate skill runs the suite in a clean clone of `HEAD`.
- An untracked file the suite needs makes P3 fail.
- The build log names the local and CI operating systems when they differ.

## Why Deferred

The human asked for it on 2026-10-31, from a review of how developers use Zero in their own repos. No run is active.
