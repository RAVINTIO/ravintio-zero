---
title: "Risk Register - narrow the brand guard self-entry"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - narrow the brand guard self-entry

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000460-narrow-brand-guard-self-entry
**Version:** 0.77.1
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The CI test and the script drift apart | low | medium | Both call one function, and AC-3 pins that | open |
| R-002 | technical | The CI test fails on the allowlist file after the row goes | medium | low | The test scope skips the two paths through the function | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Paths reach the guard relative to the repo root | The guard reports the allowlist file and fails closed | open |
