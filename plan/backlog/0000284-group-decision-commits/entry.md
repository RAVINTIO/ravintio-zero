---
title: "Backlog Entry: 0000284 - group coaching decisions into fewer commits"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000284 - group coaching decisions into fewer commits

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

The rule to commit after every meaningful artifact makes the agent commit each coaching decision on its own:

- In `ravintio/docs`, run 0000005 squashed 56 commits, and about 20 were "log X decision" commits.
- Run 0000009 made 13 commits in P0 alone, such as `chore(0000009): log copy bug 1 decision` and `record session ack`.

These commits add noise to the branch and the PR. They also slow P0, because each decision waits for a commit and its hook.

## Suggested Action

- Treat coaching records as one artifact per topic, not one per answer. Commit when a topic closes, such as scope or acceptance criteria, or when the session pauses.
- Keep committing at once for real artifacts, such as a requirement, an ADR, or `design.md`.
- Commit at once whenever the session may end, so an interruption loses at most one topic.
- Update the commit rule in the orchestrator skill and `CLAUDE.md` to say which records group.

## Wanted outcome

A feature's P0 history shows a few topic commits rather than one commit per answer. Tests check these conditions:

- The orchestrator skill states which records group into one commit.
- The rule still requires an immediate commit for each requirement, ADR, and `design.md`.

## Why Deferred

The human asked for it on 2026-10-31, from a review of consumer repos. No run is active.
