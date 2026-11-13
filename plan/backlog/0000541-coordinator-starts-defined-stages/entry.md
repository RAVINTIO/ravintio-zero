---
title: "Backlog Entry: 0000541 - Coordinator starts a defined stage without asking"
summary: "The coordinator asks \"Go?\" before a stage the pipeline already defines as next, such as I-E Delivery after the last merge."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000541 - Coordinator starts a defined stage without asking

**Source feature:** 0000360-backlog-sweep
**Source phase:** I-D Advance
**Deferral source:** human request, 2026-11-13
**Date filed:** 2026-11-13

---

## Problem

After step 61 merged, the coordinator ended its report with "should the coordinator start I-E Delivery now? Go?". The answer is always yes. The initiative skill already says to run I-E Delivery when the position passes the last step. The question made the human wait and read a decision that was not one.

Two texts invite the question:

- Rule `coord-question-form` in `roadmap-standards.md` tells the coordinator to ask "Go?" after each restated plan. It names no case where the coordinator acts without asking.
- Rule `driver-stop-summary` prints `action for the human: run initiative delivery from the initiative skill` after a clean end. The line names delivery as the human's action, not the coordinator's.

The human called the question unnecessary and asked for the standard to cover it. A memory in one session is not enough.

## Suggested Action

- Add a rule to the coordinator questions: if the pipeline defines the next stage, the coordinator starts it and reports the start as a status. It asks only at a real fork or before a human-only action, such as merging into `main`.
- In the initiative skill, say that I-E Delivery starts without a question after the driver's clean end.
- Change the clean-end summary to `action for the human: none, the coordinator runs I-E Delivery`, or similar wording.
- Add a test that the standard and the skill hold the new rule.

## Why Deferred

Found by the human at the end of initiative 0000360, after the last step merged. No step remained to carry it.
