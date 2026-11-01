---
title: "Backlog Entry: 0000221 - end-to-end test for the codex setup target"
summary: "A human-requested capability, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000221 - end-to-end test for the codex setup target

**Source feature:** none (human request)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** human request
**Date filed:** 2026-10-27

---

## Problem

The `codex` setup target has no end-to-end test. The CI suites check the files that `setup.sh codex` writes, but no test runs a real Codex session against them. Initiative 0000195 step 14 ran the checks by hand and found two gaps that the file checks missed:

- Codex skips the project `merge-guard` hook until a person trusts it with `/hooks`.
- Codex runs commands in a login shell that resets `PATH`, so a stub `gh` needs a `ZDOTDIR` `.zprofile` to come first.

Backlog entry 0000220 asks a person to verify the block after trust once, by hand. The human chose to skip that check for now and asked for a repeatable test instead.

## Suggested Action

Add a script, such as `ravintio-zero/tests/e2e/test-codex-setup.sh`, that a person runs on demand:

1. Create a fresh git repo and a separate `CODEX_HOME` in a temp folder.
2. Copy the pack in and run `setup.sh codex`.
3. Put a stub `gh` first on `PATH` through a temp `ZDOTDIR`. The stub logs its arguments and never reaches GitHub.
4. Run `codex exec` and check that Codex names the RAVINTIO skills.
5. Run `codex exec` and ask it to run a merge command. Check the exit code and the stub log.
6. Delete the temp folders.

The test must not use `--dangerously-bypass-hook-trust` or write trust settings into the person's own Codex home. P0 decides how the test reaches a trusted state. One option is a trust record that the person creates once by hand in the test's own `CODEX_HOME`. If no safe option exists, the test checks only the untrusted state: the merge command runs, and setup's warning names the gap.

The test makes model calls on the person's OpenAI account. It runs locally on request and stays out of CI unless the human approves the cost.

## Wanted outcome

One command runs the test and prints pass or fail for each check. Tests check these conditions:

- Codex names at least one RAVINTIO skill from `.agents/skills/`.
- In the state the test reaches, the merge result matches what setup's output says. A trusted hook blocks with exit 2 and leaves the stub log empty. An untrusted hook lets the command run, and setup's output says so.
- The run leaves no file outside its temp folders, and the person's Codex home stays unchanged.

## Why Deferred

The human asked for it at initiative 0000195 delivery, after choosing to skip the manual check in entry 0000220.
