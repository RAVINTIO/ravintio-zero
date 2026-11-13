# Changelog (0000421-initiative-retrospective, 10 Nov 2026)

**Feature:** Initiative retrospective
**Version:** set by the merge queue at merge
**PR:** 155

## What changed

- A retrospective of all 27 stops and mistakes in initiative 0000360, at `plan/retrospectives/0000360-backlog-sweep-retrospective.md`. It groups them into 19 findings, each with a 5 whys chain, a verdict, and an entry.
- 15 backlog entries, 0000423 to 0000437, each with `priority: "high"` and `theme: "initiative"`.
- A suggested order for steps 23 to 41, with `Lane` and `After` for each.
- The step pulls in entry 0000422 and deletes it.

## Why

The human found the run hard to oversee. Each cause that no fix covers needs its own later step.

## Deviations

- The record path follows entry 0000422, not the retrospective skill's default initiative path. The delivery stage writes its own record later.
- Three research agents could not write findings files. The orchestrator saved one and folded the others into the record.
- The baseline run did not happen at P0. P3 recorded it from a clean clone.

## Validation results

- Full suite in a clean clone: 380 passed and 2 failed. Both failures also exist on the base and pass in the worktree.
- All 27 rows appear in the record. Every finding names an entry.
- Security review: 0 critical and 0 high findings.

## Skipped phases

None.
