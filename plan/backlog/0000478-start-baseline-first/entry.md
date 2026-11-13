---
title: "Backlog Entry: 0000478 - Start the baseline run before the P0 artifacts"
summary: "The baseline suite run starts after the design, so P3 waits for the full suite. Start it first."
status: "open"
priority: "low"
theme: "initiative"
---
# Backlog Entry: 0000478 - Start the baseline run before the P0 artifacts

**Source feature:** 0000460-narrow-brand-guard-self-entry

**Source phase:** P4

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

Discovery Start Actions step 15 starts the baseline suite once the design exists. The run takes about 13 minutes in a clean clone. Step 34 waited on it before P3 could compare results. Source: `plan/retrospectives/0000460-narrow-brand-guard-self-entry-2026-11-10.md`.

## Suggested Action

Move the baseline run to the first action of P0 in `orchestrator-p0-start-actions.md`. Verify with a test that reads the step order.

## Why Deferred

The step's scope was the brand guard only.
