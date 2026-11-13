---
title: "Backlog Entry: 0000414 - local tests catch runner-only failures"
summary: "The local suite runs test workspaces with no global git identity, and covers a CLAUDE.md that starts with a BOM."
status: "open"
priority: "high"
theme: "tests"
---
# Backlog Entry: 0000414 - local tests catch runner-only failures

**Source feature:** 0000382-install-lifecycle
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-08

---

## Problem

PR #136 passed 317 feature suites and 19 regression suites locally, then failed two CI jobs:

- `bash-suites`: `commit_workspace_pack` in `ravintio-zero/tests/helpers/assert.sh` relied on the global git identity, which the CI runner lacks.
- `windows-powershell (powershell)`: Windows PowerShell 5.1 writes `CLAUDE.md` with a BOM, and `doctor` in `install-lifecycle.mjs` matched the first line without stripping it.

The local run used `pwsh` only, so it could not see the second failure.

See `plan/postmortems/2026-11-08-archived-step-cannot-fix-ci.md`.

## Suggested Action

- The test helpers set `GIT_CONFIG_GLOBAL=/dev/null` and a workspace-local identity, so a missing identity fails locally.
- Add a fixture whose `CLAUDE.md` starts with `﻿` for every script that reads a first line.

## Wanted outcome

- With the fixes from PR #136 reverted, the local suite fails on both defects.

## Why Deferred

The human asked for it as a postmortem action during I-C Run of initiative 0000360.
