---
title: "Backlog Entry: 0000608 - Step scratch uses RAVINTIO_STEP_TMP"
summary: "The driver sets RAVINTIO_STEP_TMP to the step's .t folder, and the test runner and the implement skill put scratch there, because Claude Code's Bash tool replaces TMPDIR."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000608 - Step scratch uses RAVINTIO_STEP_TMP

**Source feature:** 0000583-step-temp-cleanup-after-merge (ADR-0352)

**Source phase:** I-C Run

**Deferral source:** human request

**Date filed:** 2026-11-27

---

## Problem

Step 38 (0000583) gives each step session a private temp folder at `{worktree}/.t`. The driver sets `TMPDIR` to that folder. Claude Code's Bash tool replaces `TMPDIR` with `/tmp/claude-{uid}` in every command, so the folder is never used. Setting `CLAUDE_CODE_TMPDIR` made no difference with Claude Code 2.1.332.

Every Claude Code session of the user shares `/tmp/claude-{uid}`, including sessions in other projects. Step scratch therefore still lands in a shared folder.

A second gap showed on 2026-11-26. While the sandbox was on, `mktemp` failed in steps 36 and 37. Setup suites got an empty workspace and ran in the step worktree. They committed their fixtures into the step branch, 55 commits in step 36 and 26 in step 37. `test-0000034-req-001` also ran `grep -rl` from `/` for more than 13 hours.

## Suggested Action

- The driver sets `RAVINTIO_STEP_TMP={worktree}/.t` for each step session, next to `TMPDIR`. Claude Code does not replace a variable with this name.
- `run-tests.sh` makes its run folder under `$RAVINTIO_STEP_TMP` when the variable holds a folder that exists. Otherwise it keeps the current behaviour.
- The runner sets `GIT_CEILING_DIRECTORIES` to the run folder, so a suite that expects a folder outside a git repo still sees none.
- The implement skill and the testing standards tell the agent to put its own scratch under `$RAVINTIO_STEP_TMP` when the driver sets it.
- The workspace helpers and `test-0000034-req-001` stop with a failure when `mktemp` returns nothing. A suite never runs in the current folder or in `/` with an empty workspace path.
- ADR-0352 gains a revision that names `RAVINTIO_STEP_TMP`.

## Tests

- A test runs the driver with a stub claude and checks that the session sees `RAVINTIO_STEP_TMP={worktree}/.t`.
- A test runs `run-tests.sh` with `RAVINTIO_STEP_TMP` set and `TMPDIR` set elsewhere. Each suite sees a `TMPDIR` under `RAVINTIO_STEP_TMP`.
- A test checks that a suite in that run folder finds no git repo above it.
- A test makes `mktemp` fail and checks that the workspace helper exits non-zero, makes no commit, and runs no `grep` outside its workspace.

## Why Deferred

The human chose this fix on 2026-11-27 during initiative 0000544. It changes the driver, the runner, and the test helpers, so it waits for a future initiative.
