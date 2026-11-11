# Changelog (0000497-keep-worktree-entries, 11 Nov 2026)

**Feature:** Driver keeps uncommitted entries from a worktree
**Version:** set by the merge queue at merge
**PR:** 191

## What changed

- Before the queue removes a step worktree, the driver lists the untracked files under `plan/backlog/`. If it finds any, it keeps the worktree and stops the queue for that step. The stop line names up to five files.
- If git cannot list the files, the driver also keeps the worktree and stops. A worktree with no untracked entry goes as before.
- The ship skill tells a step to run `git status --porcelain plan/backlog` and to commit each entry it filed, by explicit path.
- The driver header and the roadmap standards state the rule.
- A new suite, `test-0000497-req-001-002-keep-entries`, covers the behaviour and the text. The scheduler fixture gains three stub modes.
- ADR 0325 records the decision.

## Why

On 2026-11-10 step 40 filed backlog entry 0000480 in its worktree and did not commit it. The removal would have deleted the entry, and the coordinator saved a copy by hand.

## Deviations

- The three requirements and the ADR share one script, so the agent ran every unit in one context with no subagents.

## Validation results

- The new suite passes 21 checks. The full suite shows no new failure and 1 inherited failure.

## Skipped phases

None.
