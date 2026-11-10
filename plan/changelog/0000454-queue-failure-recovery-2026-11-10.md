# Changelog (0000454-queue-failure-recovery, 10 Nov 2026)

**Feature:** Queue failure recovery
**Version:** set by the merge queue at merge
**PR:** #160

## What changed

- A queue rerun reverts the set-version commits that an earlier failed run left on the PR branch. It does this in one new commit before the base merge, when the base version has moved. The merge then has no conflict on the version rows.
- The queue detaches HEAD in its worktree when a run ends, on success and on every stop. A restart can then check out the step branch.
- A new suite, `test-0000454-req-001-queue-failure-recovery.sh`, runs a failed run, a base change, a restart check, and a rerun.
- ADR-0299 records the decision. The architecture overview and `roadmap-standards.md` describe the new behaviour.

## Why

A failed queue run left a `chore: set version` commit on the step branch, and the next merge conflicted on the version rows. The queue worktree also stayed on a step branch, so a restart could not check that branch out. Coordinators fixed both by hand. See backlog entry 0000429 and the initiative 0000360 retrospective.

## Deviations

- P2 ran inline without subagents, because the requirements edit one script and one suite.
- The brief left out a clean-up of files that a failed run wrote. Backlog entry 0000477 holds it.

- CodeQL flagged the first draft of the commit scan for building patterns from input. The scan now uses fixed patterns and compares the captured values.

## Validation results

- The new suite failed 9 of 18 checks before the change and passes 18 of 18 after it.
- The nine suites that name `merge-queue.mjs` pass.
- The full suite passed 381 suites in a clean clone. Two suites failed, and both also fail on the base commit.

## Skipped phases

None.
