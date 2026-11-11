---
title: "Risk Register - Ship removal needs human approval"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Ship removal needs human approval

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000519-ship-removal-needs-human-approval
**Version:** 0.101.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | `git rm` fails on an untracked file left in `plan/current/`. | low | medium | Step 4 item 5 stages everything first, so no untracked file remains. | open |
| R-002 | technical | A test pins the old wording and fails. | medium | low | The step greps the tests and updates each pin. | open |
| R-003 | operational | The safety check refuses `git rm` in some host. | low | medium | The step prints `Blocked:` with the exact error. The archive copy exists, so the coordinator can finish. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The safety check accepts `git rm -r -q plan/current`. | The step stops again at Step 4. | open |
