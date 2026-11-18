---
title: "ADR 0352: The driver removes a merged step's temp paths"
summary: "After each merge the driver removes step temp paths and extra worktrees by an anchored pattern, and suites trap stop signals."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000583-step-temp-cleanup-after-merge"
---
# ADR-0352 - The driver removes a merged step's temp paths

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Component:** ravintio-zero
**File:** `docs/adr/0352-driver-removes-merged-step-temp-paths.md`
**Date:** 2026-11-18T08:56:11Z

## Context

On 2026-11-14 the temp folder held 10,528 leaked entries and the disk filled. Step sessions leave `/tmp/step{n}*` paths and extra worktrees. Suites keep an `EXIT` trap, but bash skips it on `SIGTERM`.

## Decision

The driver calls `cleanStepTemp` after each merge and in the start sweep. It removes extra worktrees and temp entries whose name matches `^step{n}(?![0-9])`, then runs `git worktree prune`. The folders are `os.tmpdir()` and `/tmp`. `RAVINTIO_STEP_TEMP_DIRS` replaces them, so a test never touches the real folder. The removal never follows a symlink, and a failure prints a `Kept:` line. Each suite that makes a temp folder traps `TERM`, `INT`, and `HUP` and exits, so its `EXIT` trap runs.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A cron job that clears old `ravintio_*` entries | Also clears old leaks | Runs outside the repo and ignores step numbers | The repo cannot test it |
| A prefix match `step{n}*` | One glob | `step1*` removes `step10` | Removes another step's files |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New function in the driver, traps in five suites |

## Consequences

**Positive:**
- A merged step leaves no temp path or extra worktree.
- A stopped suite removes its folders.

**Negative:**
- The driver removes any `step{n}` path in the temp folder, whoever made it.

**Risks:**
- A person keeps notes at `/tmp/step3-notes`. The driver removes them after step 3 merges.

## Related ADRs

- ADR-0326 - extends

## Supersedes

- None.

## Superseded By

- None.
