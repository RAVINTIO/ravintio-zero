---
title: "Risk Register - 0000583-step-temp-cleanup-after-merge"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - 0000583-step-temp-cleanup-after-merge

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Version:** 0.146.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A suite or script deletes a path outside the repo | low | high | The driver has no name-based removal. A test plants files outside the repo and scans the pack scripts. | open |
| R-002 | technical | A suite pins the driver header or the standards text that this step edits | medium | low | The test impact scan lists each pin. The unit updates it and logs a `Rework:` line. | open |
| R-003 | technical | A signal trap changes a suite's exit code | low | medium | The trap exits with 143 or 130 only on a signal. A normal exit keeps its code. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The sandbox settings keys `enabled` and `filesystem.allowWrite` work in the installed Claude Code | The step session runs without the sandbox | open |
