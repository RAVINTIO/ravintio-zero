---
title: "Backlog Entry: 0000331 - no stash while subagents share the working tree"
summary: "A coordinator-observed risk, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000331 - no stash while subagents share the working tree

**Source feature:** none (initiative 0000312 supervision)
**Source phase:** none (initiative 0000312 supervision)
**Deferral source:** coordinator observation
**Date filed:** 2026-10-31

---

## Problem

In initiative 0000312 step 1 (0000313-driver-setup-stop), P2 ran three subagents in parallel in one working tree. Subagent U2 finished first. The step session then ran `git stash -q`, reran `test-0000189-req-007-old-name-guard.sh` on the clean tree, and ran `git stash pop -q`.

U1 and U3 were still running, with uncommitted edits to `initiative-run.mjs`, `roadmap-standards.md`, and `component.yml`. For a few seconds those edits left the disk. A subagent that read or wrote a stashed file in that window could have lost work, read stale text, or caused a conflict on pop.

This time the pop restored every edit, and no stash was left behind. The `fast` speed and the human's rule to run independent units in parallel make the overlap common.

## Suggested Action

- Add a rule to the orchestrator and implement skills. While any subagent of the step runs, the step session never runs `git stash`, `git checkout -- {path}`, `git reset`, or `git clean`.
- To test against a clean tree, use a temporary clone in a scratch folder, as retrospective 0000253 keeps.
- Record in the build log when the step waits for its subagents before a tree-wide git operation.

## Wanted outcome

No step session changes the shared working tree under a running subagent. Tests check these conditions:

- The orchestrator skill names the git commands that a step never runs while its subagents run.
- The implement skill names the scratch clone as the way to test a clean tree mid-phase.

## Why Deferred

The coordinator saw it while initiative 0000312 step 1 was in P2. The charted steps don't cover it.
