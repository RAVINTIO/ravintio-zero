---
title: "Backlog Entry: 0000266 - build logs use clock times and close every phase"
summary: "A coordinator-observed defect, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000266 - build logs use clock times and close every phase

**Source feature:** none (initiative 0000238 supervision)
**Source phase:** none (initiative 0000238 supervision)
**Deferral source:** coordinator observation
**Date filed:** 2026-10-28

---

## Problem

Step build logs in initiative 0000238 broke in two ways that entry 0000232 does not check.

**Hand-typed future times.** Some steps typed a timestamp instead of reading the clock:

| Step | Logged time | Clock at the time | Gap |
|------|-------------|-------------------|-----|
| 5 (0000243) | P2 closed `14:40:00Z`, P3 closed `14:50:00Z` | PR #60 merged at 14:20:15 UTC | 20 to 30 minutes ahead |
| 8 (0000246) | P1 start `19:44:00Z` | 19:40:25 UTC | about 4 minutes ahead |
| 9 (0000247) | Design confirmed `20:24:00Z` | 20:02:39 UTC | about 21 minutes ahead |

Round values such as `:00Z` mark a guessed time. A wall clock built from them is wrong even when it matches its own `Start` and `End`.

**Missing phase ends.** Steps 6, 7, and 9 wrote `### P{n}` headings with no `Complete:` line for some phases. The watcher reports phase ends from those lines, so it reported none. A resume reads the last `Complete:` line, so it would redo finished work.

## Suggested Action

- Tell every phase skill to read the time with `date -u +%Y-%m-%dT%H:%M:%SZ` and never to type one.
- Extend the build log check from entry 0000232 to fail on these cases:
  - a time later than the commit that adds it
  - a phase block with no `Complete:` or `Skipped:` line, unless the phase is still running

## Wanted outcome

Every build log time comes from the clock, and every finished phase has an end line. Tests check these conditions:

- The build log check fails a log whose time is later than its commit time.
- The build log check fails a finished phase block with no `Complete:` line.
- The check passes a log with a `Skipped:` line in place of a phase block.

## Why Deferred

The coordinator found it while initiative 0000238 step 10 was in P0. Step 10 picks up entry 0000232, which covers blank wall clocks only. Pickup can merge this entry with any follow-up from 0000232.
