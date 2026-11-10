---
title: "Requirement: REQ-002 - Overlap check"
summary: "The coordinator PR check names open step PRs that touch the same files."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Overlap check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000456-regenerate-shared-files-at-merge
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I want the overlap check to name open step PRs on the same files, so that I land admin safely.

## Functional Requirements
- `coordinator-pr-check.mjs` accepts `--base <branch>`. With it, the script lists open PRs with `gh pr list --base <branch> --state open --json number,headRefName,files`.
- The script reads the `gh` binary from `GH_BIN` when set.
- It skips a PR whose head is the current branch. It checks only PRs whose head starts with `feat/`.
- It ignores the files that `shared-files.mjs` resolves itself.
- For each file that a step PR and the coordinator PR both change, it prints `overlap: #{n} {path}` and exits 1.
- Without `--base`, the script behaves as before.

## Acceptance Criteria
- [ ] AC-1: Overlap found
  - Given an open `feat/` PR that changes a file the coordinator PR changes
  - When the check runs with `--base`
  - Then it prints `overlap: #{n} {path}` and exits 1
- [ ] AC-2: Resolved files ignored
  - Given an open step PR that changes only `plan/backlog/index.md`
  - When the check runs with `--base`
  - Then it prints no overlap line
- [ ] AC-3: No base flag
  - Given a run without `--base`
  - When the check runs
  - Then it makes no `gh` call and prints `plan-only` or `full-suite` as before

## Dependencies
- REQ-001 for the shared allowlist
