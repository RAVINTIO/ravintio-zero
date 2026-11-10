---
title: "Risk Register - 0000452-ci-wait-before-archive"
summary: "Technical, operational, and security risks with their mitigations."
status: "draft"
version: "0.1.0"
---
# Risk Register - 0000452-ci-wait-before-archive

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000452-ci-wait-before-archive
**Version:** 0.1.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Tests pin the old order of Step 8 and the PR. They fail after the edit. | medium | low | The impact scan lists them and U-003 updates each one | open |
| R-002 | operational | The closing archive push adds one CI run per step. | high | low | The step waits once more. A plan-only diff passes the same jobs | open |
| R-003 | technical | A check fails on the archive head and the step cannot edit code. | low | medium | The step prints `Blocked:` and names the check | open |
| R-004 | security | A sentinel file reaches the initiative branch. | low | medium | The closing commit deletes the sentinels, so the squash carries none | open |

## Assumptions Logged as Risks

This section logs documented assumptions from the specification with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The squash carries the net branch diff. | Sentinels committed early reach the initiative branch. | open |
| A-002 | A plan-only archive push needs no code edit. | A failing check on the archive head stops the step. | open |
