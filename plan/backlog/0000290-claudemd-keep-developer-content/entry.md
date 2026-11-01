---
title: "Backlog Entry: 0000290 - setup keeps a developer's own CLAUDE.md content"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000290 - setup keeps a developer's own CLAUDE.md content

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Setup writes `CLAUDE.md` from its template (`setup.sh:170-176`). If the file exists, setup overwrites it and prints only `regenerated from template`.

On a first install into an existing repo, the developer's own `CLAUDE.md` content is gone. Setup keeps no backup and gives no warning.

## Suggested Action

- On a first install, if `CLAUDE.md` exists and setup didn't write it, move its content to `ravintio-overrides/instructions/` before the write.
- Print the path that now holds the content.
- On a re-run, keep today's behaviour, because the override instructions already carry the developer's content.
- Make the same change in `setup.ps1`.

## Wanted outcome

A first install never loses a developer's `CLAUDE.md` content. Tests check these conditions:

- A first install over a custom `CLAUDE.md` writes that content to `ravintio-overrides/instructions/`.
- Setup's output names the file that holds the content.
- The new `CLAUDE.md` includes the moved content through the override instructions.

## Why Deferred

The human asked for it on 2026-10-31, from a review of how developers use Zero in their own repos. No run is active.
