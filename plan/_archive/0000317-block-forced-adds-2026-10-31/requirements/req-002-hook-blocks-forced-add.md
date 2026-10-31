---
title: "Requirement: REQ-002 - a hook blocks a forced add"
summary: "A Bash guard blocks forced adds."
status: "active"
version: "0.43.0"
---
# Requirement: REQ-002 - a hook blocks a forced add

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000317-block-forced-adds
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I want a hook that blocks a forced add, so that the rule holds when a step forgets it.

## Functional Requirements

- `block-forced-add.mjs` is a PreToolUse Bash guard. It exits 2 with a message that names the rule, and 0 otherwise.
- It blocks a `git add` that carries `-f`, `--force`, or a combined short flag that contains `f`, such as `-fA`. It blocks the form `git -C {dir} add -f`. It checks every segment of a compound command.
- It allows `git add plan/current` and any `git add` with no forced flag.
- If the command text is too complex to parse, it blocks.
- Setup wires it in `setup.sh` and `setup.ps1` as a Bash guard through `guard-run.mjs guard`, once, after `merge-guard`.

## Acceptance Criteria

- [ ] AC-1: forced forms blocked
  - Given the commands `git add -f plan`, `git add --force plan`, `git add -fA plan`, and `git -C plan add -f x`
  - When the hook reads each
  - Then it exits 2 and the message names the rule
- [ ] AC-2: plain adds allowed
  - Given `git add plan/current` and `git add -A`
  - When the hook reads each
  - Then it exits 0
- [ ] AC-3: setup wires one copy
  - Given a setup run, then a rerun
  - When `.claude/settings.json` is read
  - Then it holds one Bash entry for `block-forced-add.mjs` with `guard-run.mjs guard`

## Dependencies

none
