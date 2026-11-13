---
title: "Requirement: REQ-001 - Ship removes plan/current with git rm"
summary: "Ship Step 4 removes plan/current/ with git rm -r -q plan/current, which the safety check accepts."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Ship removes plan/current with git rm

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000519-ship-removal-needs-human-approval
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I remove `plan/current/` with `git rm -r -q plan/current`, so that the safety check accepts the removal and the step does not stop.

## Functional Requirements
- Ship Step 4 item 4 copies `plan/current/` to the archive path. It then runs `git rm -r -q plan/current` from the repo root.
- The command uses a literal path, with no `cd` and no glob.
- The ship skill names no `rm -r` of `plan/current/`.
- The copy-then-delete pins in `test-0000025-req-002-ship-agent-p7-git-add.sh` still hold.

## Acceptance Criteria
- [ ] AC-1: Step 4 names the git command
  - Given the Step 4 section of `ravintio-ship/SKILL.md`
  - When a reader looks for the removal
  - Then it runs `git rm -r -q plan/current` after the copy
- [ ] AC-2: the skill names no rm -r of plan/current
  - Given the whole ship skill
  - When a test searches for `rm -r` followed by `plan/current`
  - Then it finds none that is not part of `git rm -r`
- [ ] AC-3: the installed copies match
  - Given the source and the installed copies
  - When `sync-installed.mjs --check` runs
  - Then it reports no difference

## Dependencies
- None.
