---
title: "Risk Register - Parallel steps on worktrees"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Parallel steps on worktrees

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Version:** 0.59.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Two steps in different lanes edit one file and conflict | medium | medium | The queue merges the initiative branch into the PR branch and stops on a conflict. Chart coaching groups steps that share files. | open |
| R-002 | technical | A stale worktree or branch blocks a rerun | medium | low | The driver reuses a `running` step's worktree and removes it at merge. | open |
| R-003 | security | A worktree or control path leaves the repo through a symlink or a crafted step number | low | high | Step numbers match `^[1-9][0-9]{0,2}$`. The driver refuses a symlink and checks the real path. | open |
| R-004 | operational | The queue switches branches in the main tree and disturbs a human session | medium | high | The queue runs in its own worktree and never touches the main tree. | open |
| R-005 | technical | A copied `.claude/` goes stale after setup reruns | low | medium | The Setup stop halts new starts after a setup-relevant merge. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `git worktree` works in the host repo | The driver stops with a named error | open |
| A-002 | Setup output is git-ignored and copyable | A step starts without hooks | open |
