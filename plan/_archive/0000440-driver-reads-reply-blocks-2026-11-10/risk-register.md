---
title: "Risk Register - Driver reads blocks from the reply"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Driver reads blocks from the reply

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000440-driver-reads-reply-blocks
**Version:** 0.78.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A reply that quotes an old `Blocked:` line stops a healthy step. | low | medium | The driver reads only this session's reply. A later `Resolved:` line clears the block. | open |
| R-002 | technical | A malformed event line throws and stops the driver. | low | medium | Parse each line in a try block and skip failures. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The final `result` event holds the reply in a string field `result`. | The driver misses the block and behaves as before. | open |
