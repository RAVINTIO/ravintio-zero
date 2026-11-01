---
title: "Backlog Entry: 0000289 - setup copies whole capability skill folders"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000289 - setup copies whole capability skill folders

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Developers keep their own skills in `ravintio-overrides/capability-skills/`, and setup reinstalls them on every run (`project-operations.md:128`). `copy_capability_skills` copies only `SKILL.md` from each folder (`setup.sh:203`).

A skill that has `references/`, `scripts/`, or `assets/` folders gets installed without them. Its links to those files then point at nothing, even though the developer put the skill in the right place.

## Suggested Action

- Copy each capability skill folder in full, with its subfolders.
- Keep the warning for a folder with no `SKILL.md`, and keep skipping that folder.
- Make the same change in `setup.ps1`.

## Wanted outcome

Every file in a capability skill folder reaches `.claude/skills/`. Tests check these conditions:

- A capability skill with a `references/` file installs with that file.
- A folder with no `SKILL.md` still prints the warning and installs nothing.
- `setup.sh` and `setup.ps1` install the same files.

## Why Deferred

The human asked for it on 2026-10-31, from a review of how developers use Zero in their own repos. No run is active.
