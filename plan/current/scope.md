---
title: "Scope - 0000583-step-temp-cleanup-after-merge"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - 0000583-step-temp-cleanup-after-merge

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Version:** 0.146.0

## In Scope

- A private `{worktree}/.t` temp folder, `TMPDIR`, `GIT_CEILING_DIRECTORIES`, and the sandbox in `initiative-run.mjs`.
- Worktree removal and `git worktree prune` after each merge.
- A private `TMPDIR` in `run-tests.sh` and signal-safe traps in five suites and the git-isolation helper.
- Scratch rules in the implement skill and `testing-standards.md`.
- Four tests, one for each requirement.
- A rule line in `roadmap-standards.md` and an entry in the living docs.

## Out of Scope

- Removing entries that earlier runs leaked.
- Deleting any path by name in a shared temp folder.
- PowerShell suites.

## Deferred

Nothing deferred.
