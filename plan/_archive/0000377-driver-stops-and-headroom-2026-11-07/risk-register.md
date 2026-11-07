---
title: "Risk Register - Driver stops and headroom"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Driver stops and headroom

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000377-driver-stops-and-headroom
**Version:** 0.57.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Moving Context Hygiene breaks a test that reads it from `SKILL.md` | medium | low | The test impact scan lists each test. The base fixture check reads reference files too. | open |
| R-002 | operational | The driver changes while it runs, so step 2 runs old code | high | low | The coordinator takes the `Restart:` stop and starts a new driver. | accepted |
| R-003 | technical | A step quotes `Question:` in prose and the driver stops on it | low | medium | Match only a line that starts with the marker, as `Blocked:` does. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A `Question:` line in the build log is the stop signal | The driver misses a question | open |
