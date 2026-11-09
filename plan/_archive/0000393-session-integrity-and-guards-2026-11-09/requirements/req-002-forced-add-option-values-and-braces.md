---
title: "Requirement: REQ-002 - Forced-add guard reads option values and brace groups"
summary: "Forced-add guard reads option values and brace groups"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Forced-add guard reads option values and brace groups

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000393-session-integrity-and-guards
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I want the forced-add guard to read git option values and brace groups, so that no form forces an ignored file in.

## Functional Requirements

- `subcommandOf` skips the value after `-C`, `-c`, `--git-dir`, `--work-tree`, `--namespace`, `--config-env`, `--super-prefix`, and `--attr-source`.
- A git add or stage command that holds a brace expansion is blocked.
- Every form the guard blocks today stays blocked.

## Acceptance Criteria

- [ ] AC-1: Option value before the subcommand
  - Given the command `git --git-dir .git add $F`
  - When the guard reads it, with `--git-dir`, `--work-tree`, or `--namespace` and a literal or variable value
  - Then it exits 2
- [ ] AC-2: Brace group
  - Given the command `git add {-f,x}`
  - When the guard reads it
  - Then it exits 2
- [ ] AC-3: Clean add passes
  - Given `git add src/a.js` and `git --git-dir .git commit -m "add $V"`
  - When the guard reads them
  - Then it exits 0

## Dependencies

- None.
