# Changelog (0000405-queue-merge-subject, 08 Nov 2026)

**Feature:** Short subject for the queue's base merge
**Version:** no bump. This PR is not a chart step of initiative 0000360.
**PR:** pending

## What changed

- `merge-queue.mjs` merges the initiative branch into a step PR with the subject `{id}: Merge the initiative branch`. Before, git wrote its default subject, which named both branches.
- A new suite, `test-0000405-req-001-short-base-merge-subject.sh`, runs the queue with a blocking `commit-msg` hook and a long step branch name.
- The architecture overview and the roadmap standards name the new subject.

## Why

On 2026-11-08 the queue stopped on step 6 of initiative 0000360. Git's default subject was 106 characters, and the `commit-msg` hook allows 72. Every ready PR behind the initiative head would have stopped the same way.

## Deviations

- P2 ran inline without subagents, because the fix is one line and one test.

## Validation results

- Pending P3.

## Skipped phases

None.
