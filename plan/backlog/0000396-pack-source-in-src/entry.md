---
title: "Backlog Entry: 0000396 - the pack source moves to src/ravintio-zero/"
summary: "The pack source moves to src/ravintio-zero/ with its history, and ravintio-zero/ becomes the installed copy this repo consumes."
status: "open"
priority: "medium"
theme: "pipeline-process"
---
# Backlog Entry: 0000396 - the pack source moves to src/ravintio-zero/

**Source feature:** 0000360-backlog-sweep
**Source phase:** I-B Activate
**Deferral source:** human request
**Date filed:** 2026-11-07

---

## Problem

In this repo, `ravintio-zero/` is both the pack source and the installed pack that the hooks, the driver, and the skills run. A change to the source changes the running pack at once. The repo can't develop the pack the way a consumer repo uses it.

## Suggested Action

1. Commit a pure `git mv ravintio-zero src/ravintio-zero` with no content edits, so `git log --follow` links each file to its old path.
2. In a second commit, copy `src/ravintio-zero/` back to `ravintio-zero/` as a plain file system copy. That copy is the installed pack this repo consumes. It starts with no history.
3. Point the tests, CI, and source-side scripts at `src/ravintio-zero/`. Keep every pack reference to `ravintio-zero/` that a consumer repo reads, because consumer installs keep the root path.
4. Write down how the installed copy refreshes from the source. The two copies diverge over time by design. No symlink joins them.
5. Extend each guard that covers `ravintio-zero/` to cover `src/ravintio-zero/` too, with no new allowed forms.
6. Add the `component.yml` and docs that the `src/` rules require.

## Wanted outcome

- `git log --follow src/ravintio-zero/setup.sh` reaches commits from before the move.
- At the step's end, `ravintio-zero/` matches `src/ravintio-zero/` byte for byte.
- The full suite and CI pass against `src/ravintio-zero/`.
- Consumer installs and their paths are unchanged.

## Why Deferred

The human asked for the move during I-B Activate of initiative 0000360. It became step 20.
