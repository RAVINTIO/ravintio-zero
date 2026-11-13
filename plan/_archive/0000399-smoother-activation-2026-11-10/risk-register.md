---
title: "Risk Register - 0000399-smoother-activation"
summary: "Technical, operational, and security risks with their mitigations."
status: "draft"
version: "0.1.0"
---
# Risk Register - 0000399-smoother-activation

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Version:** 0.1.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A migration with no `Detect:` line must still report. A wrong filter hides a real migration. | low | medium | A test covers the no-Detect case in REQ-006 | open |
| R-002 | technical | Skill text caps fail after the edits to the initiative skill. The skill must stay under 120 lines. | medium | low | Keep new text short and run the cap test in U-003 | open |
| R-003 | operational | Activate half-finishes after a push failure and leaves a pushed branch. | medium | medium | A rerun detects the branch and resumes at the PR step | open |
| R-004 | security | The activate script merges a PR and could widen a guard. | low | high | Merge only the coordinator PR into `initiative/*` and add no guard form | open |
| R-005 | technical | The plan-only check skips a suite that a plan file would break. | low | medium | CI still runs on the PR and the check runs the plan format checks | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The initiative skill starts the driver and watcher as host background tasks. | The script would have to detach them itself. | open |
| A-002 | A `charted` draft in `plan/roadmap/` marks the coordinator session. | A feature session on that branch loads the initiative skill. | open |
