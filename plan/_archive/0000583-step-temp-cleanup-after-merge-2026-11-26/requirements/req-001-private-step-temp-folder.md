---
title: "Requirement: REQ-001 - Each step session gets a private temp folder"
summary: "The driver sets TMPDIR to {worktree}/.t, runs the session in the sandbox, and removes the worktree after the merge."
status: "active"
version: "0.1.1"
---
# Requirement: REQ-001 - Each step session gets a private temp folder

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Source:** US-001
**Priority:** must-have

## User Story

As the driver, I give each step session a private temp folder in its worktree, so a merged step leaves no scratch. No session then reaches a shared folder.

## Functional Requirements
- The driver creates `{worktree}/.t` and sets `TMPDIR` and `GIT_CEILING_DIRECTORIES` to it for the session and its suites.
- `.gitignore` lists `.t/`. Scripts that scan the repo tree skip it.
- If the folder path leaves less than 20 characters below the 104-character Unix socket limit, the driver stops with `I-C Run: Blocked:` and a clear message.
- The driver runs the session with `--settings` that enable the Claude Code sandbox. Writes reach the worktree, its git folder, and its control folder. The shared `/tmp` and the user temp folder stay closed.
- After the queue merges a step, the driver removes the worktree and runs `git worktree prune`. A failure prints `I-C Run: Kept: step {n} {reason}` and never stops the run.

## Acceptance Criteria
- [ ] AC-1: Private folder
  - Given a step session started by the driver
  - When the session reads its environment
  - Then `TMPDIR` and `GIT_CEILING_DIRECTORIES` equal `{worktree}/.t`
- [ ] AC-2: Sandbox
  - Given a step session started by the driver
  - When the driver builds the `claude` arguments
  - Then `--settings` enables the sandbox and allows writes to the worktree and not to `/tmp`
- [ ] AC-3: Removal after merge
  - Given step 2 merged
  - When the driver finishes the merge
  - Then the worktree and its `.t` folder are gone and `git worktree list` omits them
- [ ] AC-4: Ignore rule
  - Given the repo `.gitignore`
  - When the test reads it
  - Then it lists `.t/`
- [ ] AC-5: Socket limit
  - Given a repo path with no room for a socket name
  - When the driver starts a step
  - Then it stops with a message that names the cause

## Dependencies
- The 0000501 sweep of merged worktrees (ADR-0326).
