---
title: "Risk Register - Squash before main"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Squash before main

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000327-squash-before-main
**Version:** 0.48.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A `chore/*` PR holds a merge commit from `main`, so the count exceeds one | low | low | CI fails with the count and the author rebases and squashes | open |
| R-002 | security | `--force-with-lease` overwrites a push the agent did not see | low | low | The lease refuses the push when the remote moved. The skill limits it to `chore/*` | open |
| R-003 | security | A crafted branch name injects a shell command in the CI job | low | medium | The job passes `github.head_ref` through `env` and the script reads it with no shell | open |
| R-004 | operational | `CLAUDE.md` and `custom-001` still say `feat/`, so a human-led session cuts a branch that CI then rejects | medium | low | The build report flags both files for the human | open |
| R-005 | technical | No hook blocks a force-push, so the `chore/*` limit rests on skill text | medium | low | CI fails any PR that breaks the commit rule. The human approved the permission on 2026-10-31 | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A full checkout makes `origin/{head ref}` readable in CI | The script exits 2 and the job fails closed | open |
