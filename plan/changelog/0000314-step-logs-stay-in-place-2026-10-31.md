# Changelog (0000314-step-logs-stay-in-place, 31 Oct 2026)

**Feature:** Step logs stay in place
**Version:** 0.41.1
**PR:** pending, updated at Step 9

## What changed

- The phase guard in `test-0000042-req-006` skips `plan/.initiative-logs`. A populated step log no longer fails it, and a stale cite in a tracked skill still does.
- The orchestrator skill, the initiative skill, and `roadmap-standards.md` say a step session never moves, renames, or deletes `plan/.initiative-logs/`, `plan/.initiative-runner.lock`, or `plan/.initiative-queue/`.
- Two new test files check the rule text and that the guard suites leave the step log folder unchanged.

## Why

In a step session the git-ignored step log tripped the phase guard, and a past step session moved the folder aside to work around it. Backlog entries 0000264 and 0000265 asked for the fix.

## Deviations

- The guard cases for REQ-001 live in `test-0000042-req-006` section (d), not in a new test file. The guard function sits in that file, so the cases run against it directly.

## Validation results

- 228 feature suites passed and 1 failed. The regression suite passed 19 of 19.
- The failing suite is `test-0000164-req-007`, which reads a stale generated `CLAUDE.md`. Step 3 of initiative 0000312 fixes it. No file in this diff touches it.
- No critical or high security finding.
- No self-correction.

## Skipped phases

None
