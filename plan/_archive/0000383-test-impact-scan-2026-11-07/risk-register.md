---
title: "Risk Register - Test impact scan"
summary: "Risks of the scan change."
status: "active"
version: "0.1.0"
---
# Risk Register - Test impact scan

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000383-test-impact-scan
**Version:** 0.61.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The scan outgrows the 15 line cap in test-0000246 | medium | low | Write each cause as one line and raise the cap in the same step if needed | open |
| R-002 | technical | The skill edit breaks a pinned line in a fixture | medium | low | The scan lists the pinning suites and P2 runs them first | open |
| R-003 | operational | Skill text passes the 1720 line cap | low | medium | The edit adds about 12 lines to 1608 | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A developer repo names test folders in the stack or uses a common name | The scan says `none found` | open |
