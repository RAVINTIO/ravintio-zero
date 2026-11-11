---
title: "Risk Register - Driver runs the approved setup command"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Driver runs the approved setup command

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000448-driver-runs-approved-setup-command
**Version:** 0.91.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | The driver runs a command that a chart file names. A bad row could run any program | low | high | The helper accepts only the pack `setup.sh` path and flag words. The driver runs it with an argument array and no shell | open |
| R-002 | operational | Setup runs from stale files because the main tree lags the initiative ref | medium | medium | The driver runs setup only when the main tree matches the merged ref, or it can fast-forward the initiative branch. Otherwise it stops as before | open |
| R-003 | technical | Existing driver suites expect a stop at every `Setup:` hit | low | medium | Their charts hold no `Confirmation:` row, so they still stop. P2 reruns them | open |
| R-004 | operational | Setup fails part way and leaves hooks half installed | low | medium | The driver stops on a non-zero exit and names the failure. The coordinator reruns setup | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The main working tree sits on the initiative branch | The driver stops with the `Setup:` line as before | open |
| A-002 | The row names the command in code font | The helper finds no command and the driver stops | open |
