---
title: "Risk Register - Delivery PR lists steps in version order"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Delivery PR lists steps in version order

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000574-delivery-pr-lists-steps-in-version-order
**Version:** 0.143.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A suite that reads the script output breaks on the new table. | low | low | The suites assert on single lines. The full suite runs before ship. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |
| R-003 | technical | A suite pins the text of rule 6. | low | low | The test impact scan found none. The full suite checks again. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The version sort at line 149 stays the one source of order. | The table and the replay disagree. | open |
