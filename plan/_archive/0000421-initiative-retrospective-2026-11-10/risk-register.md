---
title: "Risk Register - 0000421-initiative-retrospective"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - 0000421-initiative-retrospective

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000421-initiative-retrospective
**Version:** 0.77.1
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A verdict of "addressed" cites a fix that does not cover the cause. | medium | high | Each such verdict cites a PR or feature id that the step read. | open |
| R-002 | security | A finding proposes a fix that widens `merge-guard` or `gate-write`. | low | high | The record marks each widening and names the guard. P3 reviews the marks. | open |
| R-003 | security | A step log holds a credential and the record copies it. | low | high | The record quotes no log text. A credential scan runs before commit. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The step logs in the main root stay readable. | A row gets the verdict "unaddressed, evidence unreadable". | open |
