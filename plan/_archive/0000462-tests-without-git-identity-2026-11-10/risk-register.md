---
title: "Risk Register - Tests catch runner-only failures"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Tests catch runner-only failures

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000462-tests-without-git-identity
**Version:** 0.80.1
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The isolation exposes many suites that rely on a global git setting | medium | low | Each gets an explicit identity in its own git call. The full suite shows them all | open |
| R-002 | technical | A suite needs another global setting, such as `safe.directory` | low | low | The suite sets it with `-c` in its own call | open |
| R-003 | technical | The PowerShell runner and the bash runner drift apart | low | medium | AC-2 of REQ-001 pins both | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Git honours `GIT_CONFIG_GLOBAL`, `GIT_CONFIG_NOSYSTEM`, and `user.useConfigOnly` | The isolation does not reproduce the CI failure | open |
