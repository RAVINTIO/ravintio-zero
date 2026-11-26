---
title: "Backlog Entry: 0000601 - Pass a timeout to background suite runs"
summary: "Background suite runs stop at the 10-minute default, but the pack suite needs about 25 minutes."
status: "open"
priority: "medium"
theme: "pipeline"
---
# Backlog Entry: 0000601 - Pass a timeout to background suite runs

**Source feature:** none (human request)

**Source phase:** none (human request)

**Deferral source:** human request

**Date filed:** 2026-11-25

---

## Problem

A background command stops after 10 minutes unless the caller passes a longer `timeout`. The pack suite needs about 25 minutes. In the consumer `claude-code-launcher`, the P0 baseline run and the first P3 clean-clone run of one step both stopped at that limit. Each stop cost a rerun and about 10 minutes.

The consumer filed this as its backlog entry 0000028.

## Suggested Action

Make step 15 of Discovery Start Actions in `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md` pass a background `timeout` of 7200000 for the suite run. Add the same sentence to `ravintio-validate-and-accept` for its clean-clone run.

## Observable condition

Both files name a background `timeout` of 7200000 for the suite run. A step's P0 suite run that takes 25 minutes ends with its own result, not a timeout.

## Why Deferred

Found in a consumer repo during an initiative run. The fix belongs to the pack, not the consumer.
