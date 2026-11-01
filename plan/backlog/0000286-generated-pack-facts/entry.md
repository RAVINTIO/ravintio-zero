---
title: "Backlog Entry: 0000286 - generate a pack facts file from the pack"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000286 - generate a pack facts file from the pack

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Writers describe Zero from memory or from scattered files, and the descriptions drift from the pack. In `ravintio/docs`, run 0000005 rewrote the pack's website. A fresh-context review found 20 problems in the pack facts the page writers used, including missing setup side effects (`0000005` build-log line 111, build-report line 32).

Nothing in the pack lists its user-facing facts in one place: its setup flags, what setup creates or changes, its hooks and what each blocks, its skills, and its phases.

## Suggested Action

- Add a script that writes a facts file, such as `ravintio-zero/pack-facts.md` or `.json`, from the pack's own sources:
  - setup flags and their effects, read from `setup.sh` and `setup.ps1`
  - files and folders that setup creates or changes
  - each hook, its event, and what it blocks
  - each skill and its description
  - the phases and stages
- Run the script in CI and fail when the committed file is stale.
- Point user docs and consumer repos at the file as the source of pack facts.

## Wanted outcome

A writer can take every pack fact from one generated file that matches the pack. Tests check these conditions:

- The script lists every flag that `setup.sh` accepts.
- The script lists every hook that setup wires.
- CI fails when the committed facts file differs from a fresh run.

## Why Deferred

The human asked for it on 2026-10-31, from a review of consumer repos. No run is active.
