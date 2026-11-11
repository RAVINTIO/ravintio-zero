---
title: "Risk Register - Driver keeps uncommitted entries from a worktree"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.106.0"
---
# Risk Register - Driver keeps uncommitted entries from a worktree

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000497-keep-worktree-entries
**Version:** 0.106.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A forgotten entry stops the merge of a ready step | low | low | The stop line names the files. The coordinator commits them in the worktree and the driver queues the step again. | open |
| R-002 | technical | Git cannot list the files, so the check passes wrongly | low | medium | A failed listing counts as unsafe. The driver keeps the worktree and stops. | open |
| R-003 | technical | A tracked-but-modified entry is not listed and still goes with `--force` | low | low | The entry targets untracked files. A modified tracked entry exists in git history. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `git ls-files --others --exclude-standard` lists every untracked, non-ignored file | An entry could still be lost, and the test pins the listing | open |
| A-002 | The coordinator accepts a refusal in place of a move | A queue stop that the coordinator clears by committing the entry | open |
