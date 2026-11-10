---
title: "Backlog Entry: 0000490 - Steps use Question only for real questions"
summary: "On 2026-11-10 step 31 ended its turn with 'I-C Run: Question: step 31 is partway through', while it only waited for its suites."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000490 - Steps use Question only for real questions

**Source feature:** 0000489-question-only-for-questions
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-10
**Date filed:** 2026-11-10

---

## Problem

On 2026-11-10 step 31 ended its turn with "I-C Run: Question: step 31 is partway through", while it only waited for its suites. It also called ScheduleWakeup, which a `claude -p` step session cannot use. A false `Question:` can read as a stop that needs the human.

Evidence: `plan/.initiative-logs/step-31.log`, 15:06 on 2026-11-10.

## Suggested Action

the orchestrator and the step instructions say that `Question:` asks the human something, and that a step waiting on its own work keeps working. A check flags a final reply whose `Question:` line holds no question mark.

## Why Deferred

Found during I-C Run of initiative 0000360, after the step 22 retrospective. The human asked for it as its own step.
