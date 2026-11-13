---
title: "Risk Register - Driver favours the critical path"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Driver favours the critical path

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000491-driver-favours-critical-path
**Version:** 0.101.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A cycle in the `After` lists loops the chain count. | low | medium | The count marks a step as visited and stops there. A test plants a cycle. | open |
| R-002 | operational | A short step in a long chain starts before a long step in a short chain. | medium | low | The rank counts steps and not time. The scope leaves duration weights out. | open |
| R-003 | technical | `readySteps` is a public export that other code and tests call. | low | medium | The signature and the return type stay the same. Existing tests keep passing. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Every step takes about the same time. | A long step in a short chain can still run late. | open |
