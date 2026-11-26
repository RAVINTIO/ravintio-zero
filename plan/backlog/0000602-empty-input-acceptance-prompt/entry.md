---
title: "Backlog Entry: 0000602 - Empty-input prompt in the requirement template"
summary: "The requirement template never asks for a criterion on empty list input, so a blank-line bug escaped to P3."
status: "open"
priority: "medium"
theme: "pack-templates"
---
# Backlog Entry: 0000602 - Empty-input prompt in the requirement template

**Source feature:** none (human request)

**Source phase:** none (human request)

**Deferral source:** human request

**Date filed:** 2026-11-25

---

## Problem

In the consumer `claude-code-launcher`, `ccl restore` printed a blank first line for a job with no sessions. No acceptance criterion named the empty list, so no test ran that case. Execution verification found it in P3.

The consumer filed this as its backlog entry 0000029.

## Suggested Action

Add a line to `ravintio-zero/templates/requirement.template.md`. It asks the author for one acceptance criterion on the empty input of each list output.

## Observable condition

A new requirement file made from the template holds a prompt for the empty-input case.

## Why Deferred

Found in a consumer repo during an initiative run. The fix belongs to the pack, not the consumer.
