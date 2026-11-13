---
title: "Risk Register - Pending migrations reach the human early"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Pending migrations reach the human early

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000536-pending-migrations-reach-the-human-early
**Version:** 0.113.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A step carries on while a migration stays pending, so a later step reads files in the old format. | low | medium | The coordinator raises each `Migration pending:` line in its next report. | open |
| R-002 | technical | Fixture-pinned tests fail when check 1 or the skill text changes. | high | low | Keep the old check 1 line verbatim and add bullets below it. | open |
| R-003 | technical | The initiative skill passes its 120-line cap. | medium | low | Add three lines at most. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The human approved each migration that has a `Migration:` row, at chart time. | A migration runs unreviewed. | open |
