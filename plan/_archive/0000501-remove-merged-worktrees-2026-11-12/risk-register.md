---
title: "Risk Register - Driver removes merged step worktrees"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.107.0"
---
# Risk Register - Driver removes merged step worktrees

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000501-remove-merged-worktrees
**Version:** 0.107.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | The sweep removes a worktree that a person still uses | low | medium | It acts only on merged steps. It needs a clean tree and a head on origin. | open |
| R-002 | technical | Git cannot inspect a worktree, so the check passes wrongly | low | medium | A failed command counts as unsafe. The driver keeps the worktree and reports it. | open |
| R-003 | operational | A kept worktree prints on every driver start | medium | low | The line names the reason. The coordinator clears it by hand. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A squash merge with `--delete-branch` removes `origin/feat/{id}` | The driver keeps a worktree that could go, and the `Kept:` line says why | open |
| A-002 | `git status --porcelain` lists every uncommitted file | A file could be lost, and the test pins the listing | open |
