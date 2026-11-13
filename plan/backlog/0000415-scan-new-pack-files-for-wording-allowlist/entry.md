---
title: "Backlog Entry: 0000415 - scan new pack files for the wording allowlist"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000415 - scan new pack files for the wording allowlist

**Source feature:** 0000391-standards-archetypes
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-09

---

## Problem

A new content file under `ravintio-zero/` can hold a word that `test-0000042-req-010-pack-wording-allowlist.sh` bans. The test-impact scan in the plan skill has no cause for a new pack content file. The subagent ran two repo-wide tests and missed this one. The full suite found the breach late.

## Suggested Action

Add a cause to the scan in `ravintio-plan/SKILL.md`: the run adds a content file under `ravintio-zero/`. List the repo-wide wording tests, including `test-0000042-req-010`.

## Wanted outcome

The execution plan lists the wording tests for a run that adds pack content. A test reads the scan and expects the new cause.

## Why Deferred

Step 15 of initiative 0000360 changes archetypes, not the plan skill. Postmortem: `plan/postmortems/2026-11-09-archetype-content-banned-word.md`.
