---
title: "Risk Register - block forced adds"
summary: "Risks for the forced-add work."
status: "active"
version: "0.43.0"
---
# Risk Register - block forced adds

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000317-block-forced-adds
**Version:** 0.43.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | The hook misses a forced-add form. | medium | medium | The hook blocks any `git` segment that names `add` with an `f` in a flag, and the CI check is the second layer. | open |
| R-002 | operational | The hook blocks a command that only mentions `git add -f` in text. | medium | low | The message says to use the Write tool, as `merge-guard` does. | open |
| R-003 | technical | Windows quoting differs in the `setup.ps1` wiring. | medium | medium | `setup.ps1` reuses the shared hook entry builder, and CI runs the PowerShell tests. | open |
| R-004 | operational | A tracked file matches an ignore rule on purpose, so the CI check fails. | low | medium | Add a negation rule to `.gitignore`. Never drop the check. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | No file in the repo today matches an ignore rule while tracked. | The check fails at once and the step adds a negation rule. | open |
