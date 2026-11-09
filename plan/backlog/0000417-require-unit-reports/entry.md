---
title: "Backlog Entry: 0000417 - require unit reports"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000417 - require unit reports

**Source feature:** 0000391-standards-archetypes
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-09

---

## Problem

One dispatched unit (U2) ended with a report that held only the word "placeholder". The orchestrator could not log its RED result and had to read the commit and rerun the suite. The dispatch standard does not say what a unit report must hold.

## Suggested Action

Add a rule to `ravintio-zero/standards/agent-dispatch-standards.md`: a unit report holds the RED line, the GREEN line, the commit hash, and any deviation. The orchestrator rejects a report that lacks one and resumes the unit.

## Wanted outcome

A unit that returns an empty report gets one resume. A test reads the standard and expects the four fields.

## Why Deferred

Step 15 of initiative 0000360 changes archetypes, not dispatch. Retrospective: `plan/retrospectives/0000391-standards-archetypes-2026-11-09.md`.
