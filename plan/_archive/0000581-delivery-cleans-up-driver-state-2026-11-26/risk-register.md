---
title: "Risk Register - Delivery cleans up driver state"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Delivery cleans up driver state

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000581-delivery-cleans-up-driver-state
**Version:** 0.151.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | The script removes a worktree that holds unmerged work. | low | medium | The script refuses while the lock exists. The coordinator runs it only after the human merged the initiative PR. | open |
| R-002 | technical | The initiative skill passes its cap of 119 lines and fails five suites. | medium | low | The delivery text edits an existing paragraph and adds one line at most. A test reads the line count. | open |
| R-003 | security | The script follows a symlink and moves a path outside `plan/`. | low | high | The script refuses a symlink at any path it touches, as `initiative-status.mjs` does. | open |
| R-004 | technical | Test 0000583 REQ-003 scans pack scripts for temp-folder removals and flags the new script. | medium | low | The script removes only paths under the repo root. P2 reads the scan before it writes the script. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The coordinator runs the script from the main working tree. | The worktree removal misses the repo and prints `Kept:`. | open |
