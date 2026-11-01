# Changelog (0000318-titled-coordinator-prs, 1 Nov 2026)

**Feature:** Titled coordinator PRs
**Version:** 0.44.0
**PR:** [#89](https://github.com/RAVINTIO/ravintio-zero/pull/89)

## What changed

- `roadmap-standards.md` states that nothing commits directly on `initiative/*`. A new `## Coordinator PRs` section sets the title form, the local suite, green CI, the agent squash, and the stopped-driver timing.
- The `## Merge carve-out` section names coordinator PRs and keeps its conditions.
- I-B Activate, the backlog queue, and I-E Delivery land as coordinator PRs.
- I-D Advance sets the changelog `**PR:**` field and pushes it before the squash. The ship skill says the same.
- The initiative skill points to the new section and holds 114 lines.
- Three new suites cover the rule, the ship order, and the `merge-guard` behaviour. `merge-guard.mjs` is unchanged.
- The architecture overview and the decisions index describe the rule.

## Why

In initiative 0000238, 23 of 38 first-parent commits on the initiative branch were direct commits with other titles. Direct commits skip CI, and one broke a content test. Backlog entry 0000274 asked for the fix.

## Deviations

- The chart format needed no change, so `initiative.md` changes only its step status and position.
- The I-D Advance text in the standards moved to the unit that owns that file.
- Commit subjects were shortened to the 72-character limit.

## Validation results

- 239 feature suites and 19 regression suites passed. No critical or high security finding. See the acceptance evidence.
- Entry 0000332 records one follow-up: `reserve-id.mjs --commit` commits on the current branch.

## Skipped phases

None
