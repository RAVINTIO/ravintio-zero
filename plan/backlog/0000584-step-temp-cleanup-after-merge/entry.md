---
title: "Backlog Entry: 0000584 - Give each step session a private temp folder"
summary: "Give each step session a private temp folder"
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000584 - Give each step session a private temp folder

**Source feature:** 0000583-step-temp-cleanup-after-merge
**Source phase:** I-B Activate
**Deferral source:** add-step helper
**Date filed:** 2026-11-14
**Scope changed:** 2026-11-26 by the human

---

## Problem

Step sessions and their suites leave temp files behind after the step merges. On 2026-11-14 the disk filled up, and the 0000544 driver stopped with `ENOSPC: no space left on device`.

The user temp folder held 10,528 leaked entries older than 2 hours, which took 26.1 GiB. Most came from four suites:

- `ravintio_0000169_req004_test_*`: 3,915 entries.
- `ravintio_0000245_req002_*`: 2,997 entries.
- `ravintio_0000151_req005_test_*`: 1,443 entries.
- `ravintio_0000171_req004_test_*`: 1,297 entries.

Step sessions also write `/tmp/step{n}*` files. Sessions in other projects use the same names. The first design for this entry deleted `/tmp/step{n}*` by name after each merge. On 2026-11-18 the driver suites ran that code against the real `/tmp`. It deleted about 2.4 GiB of another project's `/tmp/step1*` and `/tmp/step2*` files.

Nothing keeps a step session inside its worktree. The driver runs it with `--permission-mode auto`, and the permission check sees only the top-level command, not what a script does.

## Wanted outcome

Each step session keeps its scratch inside its own worktree. Nothing in the pack deletes by name in a shared folder.

- The driver gives each step session a private temp folder, `{worktree}/.t`. It sets `TMPDIR` to that folder for the session and its suites.
- The driver sets `GIT_CEILING_DIRECTORIES` to that folder, so git in a scratch folder never finds the step's repo.
- `.gitignore` lists `.t/`. Scripts that scan the repo tree skip it.
- At start, the driver checks that the temp folder path leaves room under the macOS 104-character Unix socket limit. If it does not, the driver stops with a clear message.
- Removing a merged step's worktree removes its scratch. The driver removes the worktree and runs `git worktree prune` after the merge queue merges the step PR.
- The driver runs each step session in the Claude Code sandbox, with writes allowed only in the step worktree. The sandbox does not allow the shared `/tmp` or the user temp folder.
- The test runner sets `TMPDIR` to a private folder for every suite. Every suite that makes a temp folder removes it on exit, with a `trap` on `EXIT`. The four suites above come first.
- The implement skill and the testing standards say that scratch goes under `$TMPDIR`. They ban hard-coded `/tmp` paths.
- The driver deletes nothing outside the repo. A test fails any pack script that removes a path outside the repo.

## Tests

- A test starts a step session through the driver and checks that its `TMPDIR` and `GIT_CEILING_DIRECTORIES` point at `{worktree}/.t`.
- A test checks that the step session runs in the sandbox with writes limited to the worktree.
- A test runs the four suites above and checks that the user temp folder holds no new `ravintio_*` entry afterwards.
- A test checks that the driver removes a merged step's worktree and its `.t` folder.
- A test plants a file in a temp folder outside the repo, runs the driver suites, and checks that the file still exists.
