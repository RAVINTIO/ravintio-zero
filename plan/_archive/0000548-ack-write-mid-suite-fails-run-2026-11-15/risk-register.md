---
title: "Risk Register - 0000548-ack-write-mid-suite-fails-run"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.115.0"
---
# Risk Register - 0000548-ack-write-mid-suite-fails-run

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000548-ack-write-mid-suite-fails-run
**Version:** 0.115.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | A stale marker holding a recycled pid keeps the strict hook quiet outside a run | low | low | The quiet window needs a step session, and P0 wrote an ack | accepted |
| R-002 | operational | A crashed runner leaves the marker | low | low | The hook checks the pid, so a dead pid shows the banner | mitigated |
| R-003 | technical | The marker adds an untracked file when `.gitignore` lacks the line | low | medium | The runner writes it before the first tree snapshot, so both snapshots match | mitigated |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The runner and the hook share one repo root | The prompt still arrives mid-run and the run fails as before | open |
