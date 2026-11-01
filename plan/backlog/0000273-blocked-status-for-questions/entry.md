---
title: "Backlog Entry: 0000273 - Stop using Blocked for ordinary questions"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000273 - Stop using Blocked for ordinary questions

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-30

---

## Problem

The agent writes `Blocked:` in the reply prefix whenever it asks the human a question, as in `P0 Discovery: Blocked: I need the list of copy bugs.` A question asking for clarity is a normal part of coaching, not a blocked run. The human finds the label unnecessary and misleading.

The prompts come from the status set in the orchestrator's "Phases and Response Prefixes" section, which offers Starting, Resuming, Complete, Blocked, and Skipped. None of them fits a routine question, so the agent picks `Blocked`. The same five statuses appear in the project `CLAUDE.md` reply conventions.

`Blocked:` also has a real meaning elsewhere in the pack. `workflow-governance-standards.md` counts `Blocked:` stops, and resume detection looks for a `Blocked:` line with no `Resolved:` line. A question labelled `Blocked:` risks inflating those counts.

## Suggested Action

Reserve `Blocked:` for exception stops, such as the five-attempt escalation or a security finding. Add a status for a routine question, such as `Question`, or let a question reply carry the phase prefix with no status. Update the orchestrator, the phase skills, and the `CLAUDE.md` template to match.

## Why Deferred

The human raised it during P0 of a run in the `ravintio-docs` repo. The fix belongs in the Zero pack, not in the consumer repo.
