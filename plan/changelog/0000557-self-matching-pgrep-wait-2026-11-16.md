# Changelog (0000557-self-matching-pgrep-wait, 16 Nov 2026)

**Feature:** Safe suite wait for step sessions
**Version:** set by the merge queue at merge
**PR:** 236

## What changed

The P0 start actions (step 15) and the validate skill now name the safe wait. A session waits for a background suite on its end marker or its process id. Both say never to wait with `pgrep -f`. A new test checks both texts and fails any skill or standard line that holds `pgrep -f` without `Never`.

## Why

A `pgrep -f` wait loop matches its own shell, so it never sees the suite end. Earlier steps lost up to 10 minutes per loop. Backlog entry 0000532 recorded it.

## Deviations

None. The plan added a sub-bullet under step 15 instead of rewording it, to keep the frozen-line tests green.

## Validation results

The new suite passes 7 of 7. The clean-clone run shows 469 feature suites passed and 3 failed. All 3 fail on the base commit. The regression suite shows 19 passed.

## Skipped phases

None.
