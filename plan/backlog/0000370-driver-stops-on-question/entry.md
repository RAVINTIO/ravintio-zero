---
title: "Backlog Entry: 0000370 - the initiative driver stops on a Question line"
summary: "A step that ends on Question: is resumed twice and told to carry on, so it can guess an answer only a human can give."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000370 - the initiative driver stops on a Question line

**Source feature:** 0000358-clean-step-stops-and-logs
**Source phase:** P2
**Deferral source:** human request
**Date filed:** 2026-11-07

---

## Problem

Feature 0000358 added the `Question` status and moved routine human questions off `Blocked:`. One of them is "`P0 Discovery: Question: No declared product id found`".

`initiative-run.mjs` and `initiative-watch.mjs` stop only on `Blocked:`. A step that ends its turn on `Question:` without merging is resumed up to two times with the prompt "Do not end your turn before I-D Advance: Complete: or a Blocked: line". On a resume, the step can guess the answer and carry on. After the second resume, the driver stops with `Blocked: step {n} exited without merging after 2 resumes`, which hides the question.

## Suggested Action

1. Treat a `Question:` line with no later `Resolved:` line the same as `Blocked:` in the driver and the watcher. Stop at once, with no resume, and repeat the question in the stop line.
2. Name `Question:` in the continue prompt, so a resumed step may end its turn on one.
3. Add a test with a step log that ends on `Question:`, and check that the driver stops without a resume.

## Why Deferred

The driver was out of scope for 0000358. The human asked for this entry while step 7 of initiative 0000349 ran.
