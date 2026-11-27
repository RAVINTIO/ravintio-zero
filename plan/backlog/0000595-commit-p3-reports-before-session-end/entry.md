---
title: "Backlog Entry: 0000595 - commit P3 reports before the session ends"
summary: "Step 30 ended P3 with three uncommitted reports and no P3 build-log block, so the next session had to rebuild the log."
status: "open"
priority: "medium"
theme: "pipeline-resume"
---
# Backlog Entry: 0000595 - commit P3 reports before the session ends

**Source feature:** 0000574-delivery-pr-lists-steps-in-version-order

**Source phase:** P4

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-18

---

## Problem

The first session of step 30 wrote `verification-report.md`, `security-report.md`, and `acceptance-evidence.md` and then ended. It left them untracked and wrote no P3 block or P2 close in `plan/current/build-log.md`. Resume detection reported `last phase: P2`, so the next session had to infer that P3 had finished. It also had to estimate the P2 wall clock across a two-day gap.

## Suggested Action

Have `resume-detect.mjs` report untracked P3 report files with no P3 block. Have the validate skill commit each report as it lands, then log the P3 block.

## Why Deferred

The fix changes a script and a skill. It needs its own design and tests.

Source retrospective: `plan/retrospectives/0000574-delivery-pr-lists-steps-in-version-order-2026-11-18.md`.
