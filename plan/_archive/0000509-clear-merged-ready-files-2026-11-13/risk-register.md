---
title: "Risk Register - Driver clears ready files of merged steps"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.110.0"
---
# Risk Register - Driver clears ready files of merged steps

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000509-clear-merged-ready-files
**Version:** 0.110.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | The pass removes the `ready` file of a step that a session still runs | low | medium | It acts only on merged steps and keeps the file while a `running` file names a live pid. | open |
| R-002 | technical | The pass follows a symlink and removes a file outside the control folder | low | high | It resolves the path under the root and refuses a symlink, as `readControl()` does. | open |
| R-003 | operational | A kept file prints on every driver start | medium | low | The line names the reason. The coordinator clears it by hand. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A merged step needs no `ready` file, because the chart records the merge | A new driver reads the PR from the step branch, so no work is lost | open |
| A-002 | `runningPid()` and `alive()` report a live session | The pass keeps a file that could go, and the `Kept:` line says why | open |
