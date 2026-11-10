---
title: "Backlog Entry: 0000488 - Steps apply the chart's Decisions rows"
summary: "The chart's `## Decisions` table holds pre-approved answers, such as the 2026-11-10 row for steps 25 to 41 on faster local runs."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000488 - Steps apply the chart's Decisions rows

**Source feature:** 0000487-steps-apply-decision-rows
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-10
**Date filed:** 2026-11-10

---

## Problem

The chart's `## Decisions` table holds pre-approved answers, such as the 2026-11-10 row for steps 25 to 41 on faster local runs. Step 40 ignored that row and ran a full baseline and a full suite serially in a clean clone, which cost about 30 minutes on the critical path.

Evidence: step 40 activity from 21:57 to 22:52 on 2026-11-10.

## Suggested Action

the step's P0 reads every `## Decisions` row that names its step, including a range such as `25-41`, and records each one it applies in the build log. A check fails a step build log that misses an applicable row.

## Why Deferred

Found during I-C Run of initiative 0000360, after the step 22 retrospective. The human asked for it as its own step.
