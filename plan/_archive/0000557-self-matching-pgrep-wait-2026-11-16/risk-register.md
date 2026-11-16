---
title: "Risk Register - Safe suite wait"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Safe suite wait

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000557-self-matching-pgrep-wait
**Version:** 0.133.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The new text in the validate skill breaks a size cap test | low | low | The skill holds 161 lines against a cap of 200. The unit adds two lines. | open |
| R-002 | technical | A frozen-line test rejects an edit to step 15 | low | medium | The unit adds a sub-bullet and leaves the base line as it is. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Skill and standard text is the only place that tells a session how to wait. | A script keeps the bad loop. | open |
