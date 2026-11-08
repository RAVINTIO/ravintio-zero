---
title: "ADR 004: The driver copies git-ignored setup output into each worktree"
summary: "The driver copies git-ignored setup output into each worktree"
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000379-parallel-steps-on-worktrees"
---
# ADR-0265 - The driver copies git-ignored setup output into each worktree

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

A new worktree holds only tracked files. Setup writes `.claude/`, `CLAUDE.md`, and `AGENTS.md`, which git ignores, so a step in a bare worktree has no hooks, skills, or boot file.

## Decision

After `git worktree add`, the driver copies `.claude/`, `CLAUDE.md`, `AGENTS.md`, and `.codex/` from the main root when they exist. It copies and does not link, so a step cannot change the main install.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Symlink the folders | No copy | A step can edit the main install | Isolation is the point |
| Run setup in each worktree | Fresh install | Slow, and needs the setup flags | Too heavy for each step |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs`. |

## Consequences

**Positive:**
- Each step starts with the hooks and skills of the main install.

**Negative:**
- A copy goes stale if setup reruns mid-run.

**Risks:**
- The Setup stop already halts new starts after a setup-relevant merge.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
