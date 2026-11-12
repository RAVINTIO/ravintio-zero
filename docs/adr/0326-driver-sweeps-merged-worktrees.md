---
title: "ADR 0326: Driver sweeps merged worktrees"
summary: "At start, the driver removes the worktree of each merged step when no session runs there, the tree is clean, and the head is on origin. It keeps and reports every other worktree."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0326 - Driver sweeps merged worktrees

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000501-remove-merged-worktrees
**Component:** ravintio-zero
**File:** `docs/adr/0326-driver-sweeps-merged-worktrees.md`
**Date:** 2026-11-11

## Context

The driver removes a step worktree in `queueTask()`, before it runs the merge queue. A step keeps its worktree if it merged by hand or the driver skipped its removal in an earlier run. On 2026-11-11 the worktree `plan/.initiative-worktrees/step-12` still existed, although step 12 merged on 2026-11-08. Old worktrees hold their branches and pile up.

## Decision

`schedule()` in `initiative-run.mjs` sweeps once at start. It runs after the driver reads the chart and the control folders. For each step with status `merged` and an existing worktree, it checks four things in order.

1. The `running` file of the step names no live pid.
2. `git status --porcelain -z` lists no file.
3. `git ls-remote --heads origin feat/{feature-id}` shows no branch, or shows a commit that holds the worktree head.
4. Each git command exits 0.

If all four hold, the driver removes the worktree with `git worktree remove --force`. Otherwise it keeps the worktree and prints `I-C Run: Kept: step {n} {reason}`. The run goes on in both cases.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Remove after each merge | Worktrees never pile up | The queue already removes the worktree of the step it merges. The old ones stay. | It does not reach the old worktrees |
| Remove with a separate script | The coordinator runs it when needed | One more command to remember | The driver already owns the folder |
| Stop the run on a kept worktree | The coordinator sees it at once | A leftover worktree blocks unrelated steps | A report is enough |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` gains the sweep. `roadmap-standards.md` states it. |

## Consequences

**Positive:**
- Merged worktrees stop piling up.
- The driver names each worktree that it keeps and says why.

**Negative:**
- A kept worktree prints a line on every driver start until the coordinator clears it.

**Risks:**
- A tool that expects an old worktree finds it gone. The sweep keeps any worktree with unpushed or uncommitted work.

## Related ADRs

- ADR-0325 - related-to: the sweep keeps the worktrees that ADR-0325 protects.

## Supersedes

None.

## Superseded By

None.
