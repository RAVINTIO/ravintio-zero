---
title: "Backlog Entry: 0000342 - the prefix-misses log is ignored only on one machine"
summary: "A coordinator-observed gap, filed for pickup at a future discovery run."
status: "open"
priority: "low"
theme: "guards"
---
# Backlog Entry: 0000342 - the prefix-misses log is ignored only on one machine

**Source feature:** none (initiative 0000312 supervision)
**Source phase:** none (initiative 0000312 supervision)
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01

---

## Problem

`plan/.prefix-misses.log` is ignored only through `.git/info/exclude`. A fresh clone and CI don't see it as ignored. The CI ignored-file check from feature 0000317 would therefore miss a forced add of it.

Source retrospective: `plan/retrospectives/0000312-guards-history-and-test-noise-initiative-2026-11-01.md`.

## Suggested Action

Add the path to the `.gitignore` that setup writes, and to this repo's `.gitignore`. A test could check that setup writes the rule.

## Why Deferred

The gap sits outside the scope of every initiative 0000312 step.
