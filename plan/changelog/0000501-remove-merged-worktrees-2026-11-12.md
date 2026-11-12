# Changelog (0000501-remove-merged-worktrees, 12 Nov 2026)

**Feature:** Driver removes merged step worktrees
**Version:** set by the merge queue at merge
**PR:** 192

## What changed

- At start, the driver sweeps the worktree of each merged step. It removes the worktree when three things hold. No live pid sits in the step's `running` file. `git status` lists no file. The head is on `origin/feat/{feature-id}`, or that branch is gone.
- Otherwise the driver keeps the worktree and prints `I-C Run: Kept: step {n} {reason}`. A kept worktree never stops the run.
- The driver header and the "Concurrent steps" section of the roadmap standards state the sweep.
- A new suite, `test-0000501-req-001-004-sweep`, covers the behaviour and the text.
- ADR 0326 records the decision.

## Why

On 2026-11-11 the worktree `plan/.initiative-worktrees/step-12` still existed, although step 12 merged on 2026-11-08. Only the queue removed worktrees, and only for a step that reached it in the current run.

## Deviations

- The four requirements and the ADR share one script, so the agent ran every unit in one context. One subagent ran the docs edit pass.

## Validation results

- The new suite passes 31 checks. The clean-clone full suite shows no new failure and 3 inherited failures.

## Skipped phases

None.
