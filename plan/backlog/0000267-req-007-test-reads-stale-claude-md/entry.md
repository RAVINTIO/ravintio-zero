---
title: "Backlog Entry: 0000267 - req-007 test checks phrases that left CLAUDE.md"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000267 - req-007 test checks phrases that left CLAUDE.md

**Source feature:** 0000253-refresh-setup
**Source phase:** P3
**Source retrospective:** `plan/retrospectives/0000253-refresh-setup-2026-10-29.md`
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-29

---

## Problem

`test-0000164-req-007-gate-write-doc-correction.sh` fails on any machine that has a generated `CLAUDE.md`. It checks `CLAUDE.md` for the phrases `every in-project path`, `.orchestrator-active`, and `outside the project`. Step 7 (0000245) moved those rules out of `CLAUDE.md`. The full text now sits in `ravintio-zero/standards/hook-enforcement.md`, so a fresh `CLAUDE.md` no longer holds it.

The failure stayed hidden until the step 15 refresh regenerated `CLAUDE.md` at 4,701 bytes. CI never sees it, because `CLAUDE.md` is gitignored and the test skips when the file is absent.

## Suggested Action

- Drop `CLAUDE.md` from the file list in the test, or check the skill that now holds the rules.
- Keep the other three files in the list.

## Wanted outcome

The test checks the file that holds the rules, not `CLAUDE.md`. Tests check these conditions:

- The test passes with a freshly generated `CLAUDE.md`.
- The test fails when the rule phrases leave `hook-enforcement.md`.

## Why Deferred

Found in P3 of 0000253. The fix is outside that feature.
