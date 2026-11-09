---
title: "Requirement: REQ-003 - Enforcement points"
summary: "The linter runs in commit-msg, pre-commit, and CI."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Enforcement points

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000390-prose-checks
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I see the linter run in pre-commit, CI, and `commit-msg`, so that breaches stop at commit time.

## Functional Requirements
- The `commit-msg` hook runs `check --message` and adds a warning that blocks the commit on a breach.
- The pre-commit hook runs `check --staged` and `diff --base HEAD`, and exits 1 on a breach.
- The CI workflow and the workflow template run `check` on every file and `diff` against the base branch on a pull request.
- A hook that cannot find `node` or the script skips the prose check and prints one note.

## Acceptance Criteria
- [ ] AC-1: commit-msg blocks
  - Given a commit message body with a 26-word sentence
  - When the `commit-msg` hook runs on it
  - Then it exits 1, and a clean message and a merge subject exit 0
- [ ] AC-2: pre-commit blocks staged breaches
  - Given a staged doc that adds a breach above its baseline
  - When the pre-commit hook runs
  - Then it exits 1 and names the file and line
- [ ] AC-3: CI runs both commands
  - Given the repo workflow and the workflow template
  - When a test reads them
  - Then each holds a `prose-check.mjs check` step and a `diff` step

## Dependencies
- REQ-001 and REQ-002.
