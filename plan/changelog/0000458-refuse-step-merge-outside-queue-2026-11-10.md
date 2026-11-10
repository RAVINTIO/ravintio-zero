# Changelog (0000458-refuse-step-merge-outside-queue, 10 Nov 2026)

**Feature:** Refuse a step merge outside the queue
**Version:** set by the merge queue at merge
**PR:** 162

## What changed

- `merge-guard.mjs` blocks every merge command when `RAVINTIO_INITIATIVE_QUEUE` is `1`, before it parses the command or calls `gh`.
- The carve-out in `roadmap-standards.md`, the ship skill, the invocation reference, `hook-enforcement.md`, and the architecture overview names the merge queue as the only step merge path.
- A new suite, `test-0000458-req-001-refuse-step-merge.sh`, covers the refusal, the unchanged paths, and the queue.
- Five existing guard suites unset the variable, because a step session runs them with it set.
- ADR 0301 records the decision.

## Why

Step 12 squash-merged its own PR #133 and bypassed the queue. The PR got no version, no tag, and a `pending` chart row. Backlog entry 0000431 asked for the refusal.

## Deviations

- P2 ran inline without subagents, because the change is one unit.
- The invocation reference gets a new anchored line and keeps the pinned `Merge is human-only` line as it was.

## Validation results

- The new suite fails 8 of 19 checks before the change and passes 19 of 19 after it.
- The full suite in a clean clone: 387 passed, 2 failed. Both failures exist on the base commit (0000037 req-004 and 0000318 req-004).

## Skipped phases

None.
