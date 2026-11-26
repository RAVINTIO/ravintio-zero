---
title: "ADR 0352: Step sessions use a private temp folder"
summary: "Each step session gets a temp folder in its worktree and runs in the sandbox. The driver deletes nothing outside the repo."
status: "accepted"
component: "ravintio-zero"
version: "0.1.1"
feature: "0000583-step-temp-cleanup-after-merge"
---
# ADR-0352 - Step sessions use a private temp folder

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Component:** ravintio-zero
**File:** `docs/adr/0352-step-sessions-use-a-private-temp-folder.md`
**Date:** 2026-11-18T08:56:11Z
**Revised:** 2026-11-26, after the human changed the scope of step 38

## Context

On 2026-11-14 the temp folder held 10,528 leaked entries and the disk filled. The first version of this ADR had the driver delete `/tmp/step{n}*` by name after each merge. On 2026-11-18 the driver suites ran that code against the real `/tmp`. They deleted about 2.4 GiB of another project's `/tmp/step1*` and `/tmp/step2*` files.

Nothing keeps a step session inside its worktree. The driver runs it with `--permission-mode auto`, and that check sees only the top-level command.

## Decision

Each step session keeps its scratch inside its own worktree. Nothing in the pack deletes by name in a shared folder.

- The driver creates `{worktree}/.t` and sets `TMPDIR` and `GIT_CEILING_DIRECTORIES` to it for the session and its suites.
- `.gitignore` lists `.t/`.
- The driver stops with `I-C Run: Blocked:` if the folder path leaves less than 20 characters below the macOS 104-character Unix socket limit.
- The driver runs the session in the Claude Code sandbox with `--settings`. Writes reach the worktree, its git folder, and its control folder.
- After the queue merges a step, the driver removes the worktree and runs `git worktree prune`. That removes the scratch.
- The test runner sets `TMPDIR` to a private folder for every suite. Each suite that makes a temp folder removes it with a trap on `EXIT` and exits on `TERM`, `INT`, and `HUP`.
- The implement skill and the testing standards tell the agent to put scratch under `$TMPDIR`.
- A test fails any pack script that removes a path in a shared temp folder.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Delete `step{n}*` in the shared temp folder after each merge (the first version) | Clears old paths | Deleted another project's files on 2026-11-18 | Removes paths the driver does not own |
| A cron job that clears old `ravintio_*` entries | Also clears old leaks | Runs outside the repo and ignores step numbers | The repo cannot test it |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Driver temp folder, sandbox, and worktree removal. Runner `TMPDIR`. Traps in five suites. Standards and skill text. |

## Consequences

**Positive:**
- A merged step leaves no scratch, because removing the worktree removes it.
- The driver and its suites cannot delete a path outside the repo.

**Negative:**
- The sandbox limits step writes to three folders. A step that needs another folder stops and asks.
- A repo path longer than 83 characters stops the driver.

**Risks:**
- The sandbox settings keys change in a Claude Code release. The driver test checks the `--settings` value it passes.
- Scratch from earlier runs stays where it is. This ADR does not remove it.

## Related ADRs

- ADR-0326 - extends

## Supersedes

- None.

## Superseded By

- None.
