# Changelog (0000556-step-session-finds-unfinished-step, 15 Nov 2026)

**Feature:** A step session finds an unfinished step
**Version:** set by the merge queue at merge
**PR:** 234

## What changed

- `resume-detect.mjs` prints `unfinished step: no build log and no archive, start P0` for a step session with no build log and no archive folder for its branch id.
- The script also prints `step branch commits: {n}`, the count of commits that the initiative branch lacks.
- The resume-detection reference maps both lines to check 3 and tells the session to start P0.
- The suite `test-0000556-req-001` pins the lines. `docs/architecture-overview.md` describes them.

## Why

The first session of step 56 filed a queue item and ended before it wrote a build log. The resume session could not tell where the step stood. Backlog 0000531 recorded the gap.

## Deviations

- Unit U3 (docs) has no executable check. The build log holds RED and GREEN lines for it under backlog 0000410.

## Validation results

- The requirement suite passes 10 of 10. The clean-clone suite shows 467 passed and 3 failed. All 3 failures also fail on the base commit.

## Skipped phases

None.
