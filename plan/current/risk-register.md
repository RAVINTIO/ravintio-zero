---
title: "Risk Register - A failed queue run can leave written files in the queue worktree"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - A failed queue run can leave written files in the queue worktree

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000546-queue-failure-leaves-dirty-files
**Version:** 0.126.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The restore discards a change the queue did not write. | low | medium | The clean-tree check passes first. The restore names paths and never runs `git reset --hard` or `git clean`. A test checks an untracked file. | open |
| R-002 | technical | A suite pins the last output line of the queue and fails on the new line. | low | low | The scan lists the suites. The new line prints only on a failure that changed a path. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The queue writes only the chart and the files in `version-files.txt`. | The restore leaves a written file dirty. | open |
