---
title: "Backlog Entry: 0000298 - make the first run clear to new users"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000298 - make the first run clear to new users

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

A developer's first run with Zero has several rough edges:

- `setup.sh --help` fails, and the setup banner prints garbled bytes (`setup.sh:1294`).
- The docs give the wrong skill count.
- Pause, park, and skip appear in no user doc.
- Block messages don't say how to get unblocked.
- Nothing warns that setup removes skills placed straight into `.claude/skills/`.

## Suggested Action

- Add `--help` to `setup.sh` and `setup.ps1`.
- Fix the banner bytes, and correct the counts in the docs.
- Add a day-to-day commands table to the getting-started guide, with pause, park, and skip.
- Make each hook block message say what to do next.
- In setup's output and the getting-started guide, point developers to `ravintio-overrides/capability-skills/` for their own skills.

## Wanted outcome

A new developer can install Zero and get unblocked from the docs and messages alone. Tests check these conditions:

- `setup.sh --help` exits 0 and lists every flag.
- `setup.sh` holds no invalid UTF-8.
- Every hook block message names a next step.
- The getting-started guide names `ravintio-overrides/capability-skills/`.

## Why Deferred

The human asked for it on 2026-10-31, from a review of how developers use Zero in their own repos. No run is active.
