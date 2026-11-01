---
title: "Risk Register - titled coordinator PRs"
summary: "Risks for the coordinator PR work."
status: "active"
version: "0.44.0"
---
# Risk Register - titled coordinator PRs

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000318-titled-coordinator-prs
**Version:** 0.44.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | The carve-out wording lets the agent merge more than coordinator PRs into `initiative/*`. | low | medium | The standards state three conditions. A test pins the hook, and the hook stays unchanged. | open |
| R-002 | operational | A coordinator PR races a running step on the same branch. | medium | low | The coordinator raises the PR only while the driver is stopped. | open |
| R-003 | technical | The initiative skill grows past its line cap. | medium | low | Edits stay within 7 lines. A test measures the cap. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `merge-guard` reads the PR base only, so a coordinator squash into `initiative/*` passes today. | The new pinning test fails and the step stops. | open |
