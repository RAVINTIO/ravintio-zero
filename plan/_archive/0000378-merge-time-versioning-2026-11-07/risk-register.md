---
title: "Risk Register - Merge-time versioning"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Merge-time versioning

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000378-merge-time-versioning
**Version:** 0.58.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A fixture `gh` shim differs from the real `gh`, so the queue passes tests and fails live | medium | medium | The shim covers only `pr view`, `pr checks`, and `pr merge`. The docs name each call. | open |
| R-002 | technical | A fold hides a real conflict | low | high | A fold stays only if the final tree equals the old head and the history check passes. | open |
| R-003 | security | A path in `version-files.txt` or a title reaches a shell or leaves the repo | low | high | Argument arrays only. Each path resolves under the repo root. | open |
| R-004 | operational | The queue runs while the driver still bumps in P4 and writes two versions | medium | medium | The queue is not wired to the driver until step 3. The docs say so. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Merged steps carry tags `v{Version}` | The reshape cannot find a step commit and exits 1 | open |
| A-002 | `merge-guard` allows the queue's squash merge into `initiative/*` | The merge step is blocked | open |
