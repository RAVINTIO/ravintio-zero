# Changelog (0000470-plan-rereads-files-at-the-branch-point, 10 Nov 2026)

**Feature:** Plan rereads files at the branch point
**Version:** set by the merge queue at merge
**PR:** 168

## What changed

- The plan skill gains a `## Branch-point reread` section with the rule `plan-branch-point-reread`. The plan runs `git fetch origin` and reads each file a unit edits from `origin/{base}`. It records the last commit that changed each file.
- The execution plan template gains a `## Branch-point reads` table with the columns File, Commit read, and Unit.
- The step repeats the reread if the base branch moves before the plan gate.
- A new suite, `test-0000470-req-001-branch-point-reread.sh`, checks the skill section and the template table.
- ADR 0306 records the decision.

## Why

Parallel steps change shared scripts within minutes. In step 16, a queue test fake matched a script from before another step merged. The first run sat in the CI wait. Backlog entry 0000435 asked for a reread at the branch point.

## Deviations

- P2 ran inline without subagents, because the work is one small unit.
- The initiative branch moved during P3. The step merged it and renumbered its ADR from 0305 to 0306.

## Validation results

- The new suite passes 0 of 9 checks before the change and 9 of 9 after it.
- The full suite in a clean clone passes 394 and fails 2 suites, both inherited. The regression suite passes 19.

## Skipped phases

None.
