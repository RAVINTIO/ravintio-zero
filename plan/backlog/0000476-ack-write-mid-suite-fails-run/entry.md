---
title: "Backlog Entry: 0000476 - Strict-mode ack write mid-suite fails the suite run"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "low"
theme: "initiative"
---
# Backlog Entry: 0000476 - Strict-mode ack write mid-suite fails the suite run

**Source feature:** 0000438-add-step-writes-full-feature-id
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-10

---

## Problem

The strict-mode hook asks a step session to write its session id to `plan/.orchestrator-ack` on the first prompt after a background task ends. A step that runs the full suite in the background gets that prompt mid-run. The write changes a tracked file, and `run-tests.sh` exits 1 with "Tree changed during the run: plan/.orchestrator-ack" although all 383 suites pass.

## Wanted outcome

A step session that already wrote an ack at P0 does not fail its suite run when the hook prompts again. One observable condition: a test writes the ack mid-run and the runner still exits 0 when every suite passes.

## Why Deferred

Step 23 changes the add-step helper only. Retrospective: `plan/retrospectives/0000438-add-step-writes-full-feature-id-2026-11-10.md`.
