---
title: "Backlog Entry: 0000341 - the forced-add guard misses some forms and Codex"
summary: "A coordinator-observed gap, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "guards"
---
# Backlog Entry: 0000341 - the forced-add guard misses some forms and Codex

**Source feature:** none (initiative 0000312 supervision)
**Source phase:** none (initiative 0000312 supervision)
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01

---

## Problem

Step 5 of initiative 0000312 (feature 0000317) added `block-forced-add.mjs`. Its security report rates these gaps medium:

- `git stage -f {path}`, a built-in synonym for `git add`
- a subshell, such as `(git add -f {path})` or `$(git add -f {path})`
- a flag held in a variable

Step 5 also left Codex out of scope, so Codex has no forced-add guard. The CI ignored-file check is the only backstop for these cases.

Source retrospective: `plan/retrospectives/0000312-guards-history-and-test-noise-initiative-2026-11-01.md`.

## Suggested Action

Block each form above, or block any segment the guard can't parse, as `merge-guard` does. Add the guard to the Codex adapter. Add a test case for each form.

## Why Deferred

The step scope covered the common forms only. Each widening of what the guard blocks needs its own tests.
