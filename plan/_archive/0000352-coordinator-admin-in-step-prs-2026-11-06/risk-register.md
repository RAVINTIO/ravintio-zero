---
title: "Risk Register - Coordinator admin in step PRs"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Coordinator admin in step PRs

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000352-coordinator-admin-in-step-prs
**Version:** 0.50.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A step commits a queue item that names another step. | low | low | The rule says to commit only items that name the step. The PR diff shows a slip. | open |
| R-002 | technical | A caller runs `--commit` on `initiative/*` and now fails. | medium | low | The three skills that call it change in this step, and the message names the route. | open |
| R-003 | technical | The branch lookup fails outside a git repository. | low | low | The script treats a failed lookup as no branch and keeps the old behaviour, so the commit step reports its own error. | open |
| R-004 | operational | The queue folder is ignored by git, so a step reads items the PR never shows. | high | low | The step copies content to the destination and commits that path, so the PR diff shows the result. | accepted |
| R-005 | technical | Existing tests assert the old queue wording and fail. | medium | low | P2 runs the full suite and updates those tests in the unit that edits the text. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A queue item names its step in `item.md`. | A step skips an item it should commit. | open |
