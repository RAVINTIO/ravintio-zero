---
title: "Backlog Entry: 0000257 - put a 24-hour time before each reply prefix"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000257 - put a 24-hour time before each reply prefix

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-28

---

## Problem

Replies start with a phase or stage prefix, such as `P0 Discovery:` or `I-C Run:`, but carry no time. During an initiative, the human reads many replies and watcher events in a row. They can't tell when each one happened without checking git or the build log.

## Suggested Action

- Put the local time in 24-hour `hh:mm` form before every reply prefix. Examples are `06:43 I-C Run: Starting: ...`, `06:43 P0 Discovery: Starting: ...`, and `06:43 Supervise: Complete: ...`.
- Apply the same form to the lines that `initiative-run.mjs` and `initiative-watch.mjs` print.
- An agent can't read the clock without a tool call. Have the `check-design` UserPromptSubmit hook inject the current local time, so the agent copies it in place of guessing.
- Update the `check-reply-prefix` Stop hook to accept a prefix with or without the time.
- Update the Reply Conventions in the boot template, the orchestrator skill, the initiative skill, and `roadmap-standards.md`.

## Wanted outcome

Every reply and every driver or watcher line in a run starts with the local time in `hh:mm` form. Tests check these conditions:

- The `check-reply-prefix` hook accepts `06:43 I-C Run: Starting: x` and `06:43 P0 Discovery: Starting: x`, and logs no miss for either.
- The hook still logs a miss for a reply with neither a prefix nor a time.
- A driver line and a watcher line each match `^[0-2][0-9]:[0-5][0-9] ` followed by a known prefix.
- The UserPromptSubmit hook output holds the current local time in `hh:mm` form.

## Why Deferred

The human asked for it while initiative 0000238 step 2 was in P4. The charted steps don't cover it. The sibling pack repo holds a matching entry, 0000294. That repo has no initiative stages.
