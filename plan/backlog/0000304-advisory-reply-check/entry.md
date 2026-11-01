---
title: "Backlog Entry: 0000304 - add an advisory writing check on replies"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000304 - add an advisory writing check on replies

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Chat replies aren't files, so the prose linter from entry 0000301 never sees them. The output style from entry 0000300 shapes replies, but nothing reports when a reply drifts from it.

## Suggested Action

- Add a Stop hook that runs the linter's checks on the last reply.
- Report long sentences and blocklist words as a short note to the agent.
- Never block. It stays an advisory hook, like `check-reply-prefix`, and changes no guard.

## Wanted outcome

Replies that drift from the writing standard get flagged. Tests check these conditions:

- A reply with a 30-word sentence produces a note that quotes its first words.
- The hook exits 0 in every case.

## Why Deferred

The human asked for it on 2026-10-31, from a review of Zero's writing quality. No run is active.
