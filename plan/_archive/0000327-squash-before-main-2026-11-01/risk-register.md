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
| R-006 | security | Any head ref that starts `initiative/` passes before a git call, and a PR can edit the script or workflow it runs. The name and the merge gate are the only controls (S-001, S-002) | medium | medium | The human merges every PR into `main`. The ruleset doc asks the human to require `squash-before-main` | accepted |
| R-007 | security | The script counts `origin/{head ref}`, and the policy reads the head ref name. A fork PR with a same-named base-repo branch counts the wrong branch (S-003) | low | medium | A missing ref fails closed with exit 2. Only repo writers can create base-repo branches | accepted |
| R-008 | operational | `squash-before-main` is an advisory check until the human marks it required (S-005) | medium | medium | `docs/main-ruleset.md` asks the human to require it | open |
| R-009 | operational | Discovery Start Actions step 2 now offers `hotfix/` for every run outside an initiative, so an ordinary feature can reach `main` under a hotfix name (S-006) | medium | low | Chart decision for step 10. The human reviews every PR into `main` | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A full checkout makes `origin/{head ref}` readable in CI | The script exits 2 and the job fails closed | open |
