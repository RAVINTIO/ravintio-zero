---
title: "Requirement: REQ-002 - wider forced-add guard"
summary: "block-forced-add.mjs blocks git stage, subshells, and variable expansions, and any segment it can't parse."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - wider forced-add guard

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000357-guard-gaps-closed
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I find `git stage -f`, a subshell, and a flag in a variable blocked, so that an ignored file stays out of the index.

## Functional Requirements
- The guard treats `stage` like `add` when it checks a segment.
- The guard splits a command on `(`, `)`, `{`, `}`, and the backtick, so a subshell or a command substitution becomes its own segment.
- The guard blocks a segment that holds `$` when its git subcommand is `add`, `stage`, or a variable. It cannot read the value, so it blocks.
- The guard blocks a variable glued to `git`, as in `git${IFS}add`, because that hides the subcommand.
- A commit message that holds `$`, such as `git commit -m "add $VERSION"`, passes.
- The block message names the variable case and tells the caller to write literal paths.
- A test case covers each form: `git stage -f x`, `(git add -f x)`, `$(git add -f x)`, `F=-f; git add $F x`, and `git add "${F}" x`.
- A plain `git add x` and `git stage x` still pass.

## Acceptance Criteria
- [ ] AC-1: each form is blocked
  - Given a Bash call with one of the five forms
  - When `block-forced-add.mjs` reads it
  - Then it exits 2
- [ ] AC-2: plain adds pass
  - Given `git add src/a.js` and `git stage src/a.js`
  - When the guard reads them
  - Then it exits 0
- [ ] AC-3: existing forms stay blocked
  - Given `git add -f x`, `git add --force x`, and `git -C dir add -fA`
  - When the guard reads them
  - Then it exits 2

## Dependencies
- None.
