---
title: "Risk Register - Steps use Question only for real questions"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Steps use Question only for real questions

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000489-question-only-for-questions
**Version:** 0.99.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A real question ends without a question mark and draws a warning. | medium | low | The hook only warns and logs. The warning says the miss does not stop a run. | open |
| R-002 | operational | A false question holds a question mark and passes the check. | low | low | The skill text is the main control. The check is a second signal. | open |
| R-003 | technical | The orchestrator `SKILL.md` has 48 bytes left under its 9,000-byte cap. | high | medium | The rule text goes to `roadmap-standards.md` and `pipeline-reference.md`. `SKILL.md` gets a net change of 48 bytes or fewer. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The status line is the first non-empty line of the reply. | The check misses a `Question:` line deeper in the reply. | open |
