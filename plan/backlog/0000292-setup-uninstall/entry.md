---
title: "Backlog Entry: 0000292 - add an uninstall to setup"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000292 - add an uninstall to setup

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Setup changes several things in a developer's repo, and nothing reverses them:

- the git `core.hooksPath` setting (`setup.sh:710`)
- hook entries and settings in `.claude/settings.json`
- the CI workflow and `.gitattributes`
- folders under `plan/` and the installed skills and commands

A developer who wants to stop using Zero must find and undo each change by hand.

## Suggested Action

- Add `setup.sh uninstall` and the same command in `setup.ps1`.
- Remove only what setup wrote, using its manifest. Keep the developer's own `settings.json` entries and their own files.
- Leave `plan/` records in place, and list them in the output, so the developer decides what to keep.
- Print each change it reverses.

## Wanted outcome

A developer can remove Zero's setup changes with one command and keep their own work. Tests check these conditions:

- After uninstall, `core.hooksPath` is unset and `.claude/settings.json` holds no RAVINTIO hook.
- A developer's own `settings.json` entries survive uninstall.
- Uninstall deletes nothing under `plan/`.

## Why Deferred

The human asked for it on 2026-10-31, from a review of how developers use Zero in their own repos. No run is active.
