---
title: "Risk Register - the version bump writes both pack copies"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - the version bump writes both pack copies

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000420-version-both-copies
**Version:** 0.76.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A typo in an optional path goes unseen | low | low | The test pins the shipped list | open |
| R-002 | operational | Step 21 merges before this fix | low | medium | The driver stays stopped until this PR merges | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Only the pack repo has `src/ravintio-zero/` | A consumer with that folder gets the version there too | open |
