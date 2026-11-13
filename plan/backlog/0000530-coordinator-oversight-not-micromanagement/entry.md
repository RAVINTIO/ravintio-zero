---
title: "Backlog Entry: 0000530 - Initiative skills do not micromanage"
summary: "Reduce context use by ensuring the initiative skills don't micromanage."
status: "open"
priority: "high"
theme: "skills"
---
# Backlog Entry: 0000530 - Initiative skills do not micromanage

**Source feature:** 0000360-backlog-sweep
**Source phase:** I-C
**Deferral source:** human request
**Date filed:** 2026-11-12

---

## Requirement

Reduce context use by ensuring the initiative skills don't micromanage.

The coordinator gives oversight. It delegates to the driver and the steps and asks for progress. It looks into step detail only in an emergency.

Start by reviewing context use per session in the Claude OpenTelemetry data. That data lives outside this repo. Use it to confirm the problem and to set a baseline.

## Problem

On 2026-11-12 the coordinator session's context seemed high while step 55 ran. The coordinator tracked each step tool call and read step test output that the step already checks. Nobody has measured how high the context went.

## Why Deferred

Step 56 changes the driver, not the initiative skills. The work needs its own feature.
