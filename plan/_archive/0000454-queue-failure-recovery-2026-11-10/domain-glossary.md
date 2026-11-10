---
title: "Domain Glossary - queue failure recovery"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - queue failure recovery

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000454-queue-failure-recovery
**Version:** 0.78.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Set-version commit | The queue's commit `chore({id7}): set version {v} for step {n}`. It writes the version files and the chart row to the PR branch. | version commit | ravintio-zero |
| Stale set-version commit | A set-version commit whose version differs from the next version that the base branch gives now. | none | ravintio-zero |
| Queue worktree | The worktree at `plan/.initiative-worktrees/queue` where the driver runs `merge-queue.mjs`. | none | ravintio-zero |
| Detached HEAD | A checkout that names no branch, so another worktree can check out any branch. | detached worktree | ravintio-zero |
