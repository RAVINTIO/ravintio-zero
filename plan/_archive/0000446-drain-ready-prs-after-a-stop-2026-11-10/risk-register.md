---
title: "Risk Register - Merge ready PRs after a stop"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Merge ready PRs after a stop

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000446-drain-ready-prs-after-a-stop
**Version:** 0.91.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A CI outage fails every ready PR in turn, and each one waits for its CI watch. | low | low | Each step gets one attempt per run, so the run ends. | open |
| R-002 | technical | A failed queue run leaves files in the queue worktree and breaks the next PR. | medium | medium | `prepareQueue` detaches the worktree at the fresh ref. Backlog 0000477 tracks cleanup. A second failure only adds a stop line. | accepted |
| R-003 | technical | The final stop line names a later failure and hides the first. | medium | low | The driver keeps the first stop message. A test checks it. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A ready step never shares a lane with a failed step, and never lists it in `After`. | A drained PR could depend on an unmerged step. | open |
