---
title: "Backlog Entry: 0000174 - skill evaluation suite against fixed briefs"
summary: "A deliberate scope split from 0000100, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000174 - skill evaluation suite against fixed briefs

**Source feature:** none (roadmap 0000168 chart)
**Source phase:** none (initiative chart)
**Deferral source:** deliberate scope decision
**Date filed:** 2026-10-25

---

## Problem

Backlog entry 0000100 asked for an evaluation suite that runs the skills against fixed briefs. A skill change could then show a before-and-after score. The roadmap 0000168 chart split the suite out of 0000100. Running skills against briefs needs paid `claude -p` calls, which count as a new service.

## Suggested Action

Write a small set of fixed briefs and a runner that drives each through the pipeline. Score each run with the workflow metrics that 0000100 adds. Decide where the runner runs, and who pays for the model calls.

## Why Deferred

The human confirmed the split at the roadmap 0000168 chart. The suite needs approval for a new service and its own cost decision.
