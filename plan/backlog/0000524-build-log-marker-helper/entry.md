---
title: "Backlog Entry: 0000524 - Build log marker helper"
summary: "A script writes RED, GREEN, and Done marker lines with a clock read, so no unit types a time."
status: "open"
priority: "medium"
theme: "pipeline"
---
# Backlog Entry: 0000524 - Build log marker helper

**Source feature:** 0000499-reply-times-match-clock
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-11

---

## Problem

Step 51 wrote its RED and GREEN marker times after the runs. The agent typed them by hand, so they are approximate. The build log notes this. The rule says every time comes from a clock read.

## Suggested Action

Add `ravintio-zero/scripts/build-log-mark.mjs`. It takes a marker kind and a unit, reads the clock, and appends the line to `plan/current/build-log.md`. The implement skill then names the script for each RED, GREEN, and Done line.

## Why Deferred

Found in step 51. The implement skill and a new script are outside the step's scope.
