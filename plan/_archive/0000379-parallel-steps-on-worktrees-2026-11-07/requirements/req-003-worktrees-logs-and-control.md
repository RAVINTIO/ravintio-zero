---
title: "Requirement: REQ-003 - Worktrees, logs, and control areas"
summary: "Worktrees, logs, and control areas"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Worktrees, logs, and control areas

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Source:** US-002
**Priority:** must-have

## User Story

As a coordinator, I want each running step to have its own worktree, log, and control area, so that steps do not share files.

## Functional Requirements

- The driver cuts each step's branch `feat/{feature-id}` from the initiative branch head with `git worktree add` at `plan/.initiative-worktrees/step-{n}`. It reuses the worktree of a `running` step on a restart.
- The driver copies the git-ignored setup output (`.claude/`, `CLAUDE.md`, `AGENTS.md`, `.codex/`) into the worktree when present.
- The step runs with `cwd` set to its worktree and the environment `RAVINTIO_INITIATIVE_STEP=1`, `RAVINTIO_INITIATIVE_QUEUE=1`, `RAVINTIO_INITIATIVE_ROOT` (main root), and `RAVINTIO_INITIATIVE_CONTROL` (the step's control folder).
- Each step writes its stream to `plan/.initiative-logs/step-{n}.log` as today. The control folder is `plan/.initiative-control/step-{n}/`.
- The driver adds the worktree and control folders to `.git/info/exclude`, and refuses a symlink in either path.
- The driver holds the one lock, `plan/.initiative-runner.lock`. A step holds no lock.
- The driver removes a step's worktree after the step merges. A stopped step keeps its worktree.

## Acceptance Criteria

- [ ] AC-1: a step runs in its own worktree
  - Given a stub `claude` that records its `cwd` and environment
  - When the driver starts a step
  - Then `cwd` is `plan/.initiative-worktrees/step-{n}`, on branch `feat/{feature-id}`, and the variables are set
- [ ] AC-2: setup output reaches the worktree
  - Given an ignored `.claude/` and `CLAUDE.md` in the main root
  - When the driver starts a step
  - Then both exist in the worktree
- [ ] AC-3: a merged step's worktree goes
  - Given a step that merged
  - When the driver moves on
  - Then its worktree folder is gone and its log remains

## Dependencies

- REQ-002
