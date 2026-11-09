---
title: "Backlog Entry: 0000406 - scan every size cap for an edited skill"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000406 - scan every size cap for an edited skill

**Source feature:** 0000388-replies-and-questions
**Source phase:** P1
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-07

---

## Problem

The P1 test impact scan named the 9000 byte cap on the orchestrator `SKILL.md`. It missed the stricter 8700 byte cap in `tests/test-0000377-req-001-context-hygiene-reference.sh`. A unit grew the skill to 8710 bytes and a test failed.

## Suggested Action

- Make the size cap scan list every test that measures the edited skill, with each cap value.
- Plan the unit's growth against the lowest cap.

## Wanted outcome

The plan states the lowest cap for an edited skill. A test checks that the scan text asks for every cap, not the first match.

## Why Deferred

The step shipped. Changing the plan skill is outside its scope.
