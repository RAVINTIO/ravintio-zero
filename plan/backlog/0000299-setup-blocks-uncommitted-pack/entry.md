---
title: "Backlog Entry: 0000299 - setup refuses uncommitted pack or override files"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000299 - setup refuses uncommitted pack or override files

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Setup copies whatever is in `ravintio-zero/` and `ravintio-overrides/`. That includes edits that nobody reviewed or committed. An accidental change to a hook, skill, or instruction then reaches `.claude/` with no record.

Outside a git repo, setup prints a warning and carries on (`setup.sh:713`).

## Suggested Action

- Before setup copies anything, check both folders with `git status --porcelain`.
- If either folder has modified, staged, or untracked files, fail. List each file, copy nothing, and say to commit or discard the changes first.
- Skip files that git ignores, so build output and local caches don't block setup.
- Give the check no bypass flag. A commit or a discard is the only way past it.
- If setup runs outside a git repo, fail with a clear message.
- Have the update command from entry 0000283 commit new pack files before it runs setup. Have the getting-started guide say to commit the pack before the first setup run.
- Make the same change in `setup.ps1`.

## Wanted outcome

Setup installs only committed pack and override files. Tests check these conditions:

- An uncommitted change in `ravintio-zero/` makes setup exit non-zero, name the file, and copy nothing.
- An untracked file in `ravintio-overrides/` does the same.
- An ignored file doesn't block setup.
- Setup outside a git repo exits non-zero with a clear message.

## Why Deferred

The human asked for it on 2026-10-31, from a review of how developers use Zero in their own repos. No run is active.
