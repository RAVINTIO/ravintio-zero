---
title: "Backlog Entry: 0000343 - each setup stop costs a PR for one timestamp"
summary: "A coordinator-observed gap, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "initiative-driver"
---
# Backlog Entry: 0000343 - each setup stop costs a PR for one timestamp

**Source feature:** none (initiative 0000312 supervision)
**Source phase:** none (initiative 0000312 supervision)
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01

---

## Problem

Setup rewrites `writtenAt` in the tracked `plan/state/claude-code.md` at every rerun. In initiative 0000312, each `Setup:` stop then needed a coordinator PR with a full local suite and CI only to commit that timestamp. Each one cost about 12 to 20 minutes. PRs #83, #86, #88, #90, #93, #95, and #97 carried setup records.

Source retrospective: `plan/retrospectives/0000312-guards-history-and-test-noise-initiative-2026-11-01.md`.

## Suggested Action

Leave the tracked record unchanged when only the timestamp would change. Another option is to move `writtenAt` to an ignored file. A test could run setup twice and expect a clean tree.

## Why Deferred

The change touches setup and its record format, which needs its own step.
