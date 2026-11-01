---
title: "Backlog Entry: 0000303 - add an edit pass for user-facing docs at P3"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000303 - add an edit pass for user-facing docs at P3

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

A script can't catch every writing problem. It misses items grouped in threes for rhythm, a definition packed into one sentence, and a fragment that restates the sentence before it. Today nothing reviews changed docs for these before ship.

## Suggested Action

- At P3, dispatch a fresh-context subagent to review each changed user-facing doc against `writing-standards.md`.
- Use the prose linter from entry 0000301 as the loop's pass condition, through `ravintio-loop-runner`.
- Have the subagent fix what it finds and report what it changed in the build log.
- Scope it to `docs/`, READMEs, and the changelog, not to plan records.

## Wanted outcome

Changed user-facing docs get a standards review before ship. Tests check these conditions:

- The validate skill names the edit pass and its scope.
- The edit pass ends only when the linter passes on the changed docs.

## Why Deferred

The human asked for it on 2026-10-31, from a review of Zero's writing quality. No run is active.
