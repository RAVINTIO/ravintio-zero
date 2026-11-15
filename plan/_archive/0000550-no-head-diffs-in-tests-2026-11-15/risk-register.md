---
title: "Risk Register - 0000550-no-head-diffs-in-tests"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - 0000550-no-head-diffs-in-tests

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000550-no-head-diffs-in-tests
**Version:** 0.125.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The pattern misses a form such as `git diff @` | medium | low | The pattern lists `HEAD`, `HEAD~n`, `HEAD^`, `@`, and `ORIG_HEAD`, and a planted case covers each | open |
| R-002 | technical | The pattern flags a legitimate diff in an existing suite | low | medium | A scan of all suites runs before the check merges | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The four `--base HEAD` uses pass an argument to a script and are not git diffs | The check fails on them and needs an allowlist | open |
