---
title: "Backlog Entry: 0000611 - A step sandbox that allows push and temp folders"
summary: "Bring back the Claude Code sandbox for step sessions with SSH push, a working mktemp, and a live test, so a step can still ship."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000611 - A step sandbox that allows push and temp folders

**Source feature:** 0000583-step-temp-cleanup-after-merge (ADR-0352)

**Source phase:** I-C Run

**Deferral source:** `plan/retrospectives/0000544-priority-backlog-initiative-2026-11-27.md`

**Date filed:** 2026-11-27

---

## Problem

Step 38 (0000583) ran each step session in the Claude Code sandbox, with writes limited to the worktree, its git folder, and its control folder. In steps 36 and 37 the sandbox caused these failures:

- `git push` over SSH failed with `Permission denied (publickey)`. The sandbox denied `github.com:22` and gave no access to the SSH agent.
- `mktemp -d` failed with `Operation not permitted`. The Bash tool's temp folder, `/tmp/claude-{uid}`, sat outside the allowed paths.
- Setup suites then ran with an empty workspace and committed fixtures into the step branches.

PR #256 removed the sandbox. Step sessions now write anywhere the user can, which is the risk that step 38 set out to limit.

## Suggested Action

- Find the sandbox settings that allow:
  - network access to `github.com` for SSH and HTTPS
  - the SSH agent socket
  - writes to the step's temp folder from entry 0000608
- Run a live probe in a real `claude -p` step session before the driver uses the settings. The probe pushes a throwaway branch, runs `mktemp -d`, and checks that a write to `/tmp` and to the home folder fails.
- The driver turns on the sandbox only with a setting such as `RAVINTIO_STEP_SANDBOX=1`, until the probe passes on each supported Claude Code version.
- If a write outside the allowed paths fails, the step stops with a `Blocked:` line that names the path. It does not carry on with an empty path.
- ADR-0352 gains a revision for the result.

## Tests

- A driver test with a stub claude checks that the `--settings` value names the network host, the agent socket, and the step temp folder.
- A driver test checks that the driver passes no `--settings` when the setting is off.
- A live probe script, run by hand or in a nightly job, reports push, `mktemp`, and blocked-write results for the installed Claude Code version.

## Why Deferred

The human asked for the entry on 2026-11-27 during I-E Delivery of initiative 0000544. It needs live testing against Claude Code, so it waits for a future initiative. Entry 0000608 should land first, because this entry uses its temp folder.
