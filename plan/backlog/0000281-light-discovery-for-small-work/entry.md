---
title: "Backlog Entry: 0000281 - a light discovery track for small work"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000281 - a light discovery track for small work

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

P0 Discovery takes most of a consumer run's time, even for small work:

- In `ravintio/docs`, run 0000005 spent 1,230 of 1,255 minutes in P0, across two calendar days. Plan to ship took 24 minutes (`plan/_archive/0000005-*/build-report.md` line 16).
- In the same repo, bug-fix run 0000009 made 13 commits in P0 and was still in P0 after two days.
- The pack that Zero replaced hit the same problem 5 times in `rapid-prototypes`. That repo wrote its own override, because "every governance run improvises the same four exceptions".

Full coaching suits a new feature. A bug fix, a copy change, or a dependency bump needs far fewer questions.

## Suggested Action

- Add a light P0 track for bug fixes and small changes. Discovery proposes the track from the brief, and the human confirms it.
- The light track asks only the questions the change needs, such as the expected behaviour, the acceptance check, and the version bump. It skips the Scope Lock Challenge and the full gate checklist.
- It still writes `discovery.md`, `design.md`, and the build log, so the hooks and later phases work unchanged.
- If the change turns out larger than it looked, discovery switches to the full track and says why.

## Wanted outcome

A small change reaches a confirmed design in minutes, not days. Tests check these conditions:

- The orchestrator offers the light track when the brief describes a fix or a small change.
- The light track writes a complete `design.md` that `gate-write` and `check-design` accept.
- A light run that grows switches to the full track and logs the switch.

## Why Deferred

The human asked for it on 2026-10-31, from a review of consumer repos. No run is active.
