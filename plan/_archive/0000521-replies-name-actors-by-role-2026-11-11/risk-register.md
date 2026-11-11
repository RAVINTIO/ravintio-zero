---
title: "Risk Register - Replies name actors by role"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Replies name actors by role

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000521-replies-name-actors-by-role
**Version:** 0.103.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The hook flags a quoted "I" or "you" in a run reply. | medium | low | The rule skips code and `>` lines. The hook stays advisory. | open |
| R-002 | technical | The orchestrator skill goes over 9000 bytes. | high | medium | The edit trims text in the same file. A test measures the size. | open |
| R-003 | technical | A test pins the old heading or the old rule text. | medium | low | The step greps the tests and updates each pin. | open |
| R-004 | operational | `CLAUDE.md` keeps the old text until setup regenerates it. | medium | low | Git ignores `CLAUDE.md`. The coordinator reruns setup after the merge, as for any pack change. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A run reply opens with `hh:mm` and a run prefix. | The hook skips a reply it should check. | open |
