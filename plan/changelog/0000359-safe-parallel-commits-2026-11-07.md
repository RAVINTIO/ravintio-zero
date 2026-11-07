# Changelog (0000359-safe-parallel-commits, 07 Nov 2026)

**Feature:** Safe parallel commits
**Version:** 0.56.0
**PR:** 120

## What changed

- The orchestrator skill adds one rule: never run `git stash`, `git checkout -- {path}`, `git reset`, or `git clean` while any subagent runs.
- The implement skill gains a `### Shared tree` section. It repeats the ban, names a scratch clone as the way to test a clean tree mid-phase, and asks the step to log in the build log when it waits for its subagents before a tree-wide git operation.
- `## Fast batches` in `agent-dispatch-standards.md` tells each unit to commit with `git commit -m "{message}" -- {paths}` and bans `git commit --amend` in a batch.
- Two new suites check each rule.
- Backlog entries 0000331 and 0000336 are pulled in and deleted.

## Why

Parallel units share one working tree and one index. A step once stashed the tree under three running subagents, and a plain `git commit` once took another unit's staged files.

## Deviations

- Units ran inline, not as subagents.
- The orchestrator rule is one line, because the skill held 8779 of 9000 bytes. The fuller rule is in the implement skill.

## Validation results

- The full suite passes: 286 feature suites and 19 regression suites. The consistency check and the self-description check pass.
- 4 criteria verified by execution. 0 failed. 1 not-verifiable here: the hook and setup check after the setup rerun, which the coordinator runs.
- Security review found no critical, high, or medium findings.

## Skipped phases

None.
