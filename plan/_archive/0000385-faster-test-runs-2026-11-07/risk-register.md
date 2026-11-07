---
title: "Risk Register - Faster test runs"
summary: "Risks of the affected-test, baseline, and clean-clone change."
status: "active"
version: "0.1.0"
---
# Risk Register - Faster test runs

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000385-faster-test-runs
**Version:** 0.61.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A cycle runs too few tests and a break surfaces late | medium | medium | One full suite run before P2 completes and another at P3 | open |
| R-002 | technical | A baseline entry hides a regression in the same suite | low | medium | The build report lists every inherited failure for review | open |
| R-003 | operational | The clean clone leaves a temporary folder after a crash | low | low | The script removes the folder on every exit path and a suite checks it | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `git clone` of a local path works on every runner | The script exits non-zero with the git error | open |
| A-002 | The runner prints each failed suite on its own line under `Failed suites:` | The baseline records nothing and P3 stops on every failure | open |
