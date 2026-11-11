---
title: "Risk Register - Check mergeability before a CI wait"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Check mergeability before a CI wait

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000483-mergeability-before-ci-wait
**Version:** 0.91.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Existing suites stub `gh pr view` with no `mergeable` field and a changed wait breaks them | low | medium | The read treats a missing value as not conflicting. P2 runs every suite that names `merge-queue.mjs` | open |
| R-002 | operational | GitHub reports `UNKNOWN` for a while after a push and the queue stops too early | low | medium | The queue stops only on `CONFLICTING`. It keeps polling on `UNKNOWN` | open |
| R-003 | operational | A slow runner takes more than 10 minutes to register a check and the queue stops | low | low | `MQ_NOCHECKS_MS` sets the limit and the error names it. A rerun resumes the queue | open |
| R-004 | technical | The skill-text total passes its 1720-line cap | low | low | The ship skill gains about 2 lines | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | GitHub reports `CONFLICTING` for a conflicting PR | The no-checks timeout still stops the wait | open |
| A-002 | `UNKNOWN` is transient | The no-checks timeout stops the wait | open |
