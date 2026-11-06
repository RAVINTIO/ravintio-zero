---
title: "Scope - Guard gaps closed"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Guard gaps closed

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000357-guard-gaps-closed
**Version:** 0.54.0

## In Scope

- ` || exit 2` on each guard-mode hook command in `setup.sh` and `setup.ps1`, for Claude Code and Codex.
- `block-forced-add.mjs` blocks `git stage`, subshells, command substitution, and a variable in a `git add` segment.
- The forced-add guard in the Codex adapter, in both setup scripts and their report lines.
- `plan/.prefix-misses.log` in `ravintio-zero/.gitignore` and in this repo's `.gitignore`.
- A test for each form, and updates to `hook-enforcement.md`.

## Out of Scope

- Advisory hook commands. Exit 2 on a Stop or UserPromptSubmit hook blocks the session.
- A change to `merge-guard.mjs`.
- Adding the ignore rule to a consumer repo that already holds a `.gitignore`. Setup keeps an existing file.
- A shell other than a POSIX shell for the Claude Code hook command.

## Deferred

Nothing deferred.
