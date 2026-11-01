---
title: "Backlog Entry: 0000291 - teammates who clone get set up, and strict mode can be turned off"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000291 - teammates who clone get set up, and strict mode can be turned off

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Setup's hooks, `CLAUDE.md`, and the `core.hooksPath` setting don't all travel with a clone. A teammate who clones a RAVINTIO repo gets no guards until they run setup, and no doc tells them to.

Strict mode has the same gap in reverse. `--strict-orchestrator` writes `plan/.orchestrator-strict` (`setup.sh:1302`). No flag or command removes it, so a re-run without the flag leaves strict mode on.

## Suggested Action

- Add a "Joining a RAVINTIO repo" section to the getting-started guide. It names the setup command to run after a clone.
- Make a setup re-run apply exactly the flags it receives. A re-run without `--strict-orchestrator` removes `plan/.orchestrator-strict` and says so.
- Have the session-start hook warn when the repo has a pack but this clone has no hooks wired.

## Wanted outcome

A teammate who clones gets the guards after one documented step, and the current flags decide strict mode. Tests check these conditions:

- A re-run without `--strict-orchestrator` removes `plan/.orchestrator-strict`.
- A re-run with the flag keeps it.
- The getting-started guide has a joining section that names the setup command.

## Why Deferred

The human asked for it on 2026-10-31, from a review of how developers use Zero in their own repos. No run is active.
