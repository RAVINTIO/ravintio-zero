---
title: "Backlog Entry: 0000416 - no HEAD diffs in tests"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000416 - no HEAD diffs in tests

**Source feature:** 0000391-standards-archetypes
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-09

---

## Problem

A test that runs `git diff HEAD` on a file passes with no change once someone commits the work. A subagent wrote two such checks in `test-0000391-req-008-standard-text.sh`. They passed without testing anything. No standard or check names this pattern.

## Suggested Action

Add a rule to `ravintio-zero/standards/testing-standards.md`: a test never compares the working tree with `HEAD` or a moving ref. Add a check to `ravintio-zero/tests/` that greps suites for `diff` against `HEAD`.

## Wanted outcome

A suite that diffs against `HEAD` fails the style check. A test plants one and expects the failure.

## Why Deferred

Step 15 of initiative 0000360 changes archetypes, not testing standards. Postmortem: `plan/postmortems/2026-11-09-test-diffed-against-head.md`.
