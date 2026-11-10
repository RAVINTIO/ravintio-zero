# Changelog (0000468-reply-time-matches-the-clock, 10 Nov 2026)

**Feature:** Reply time matches the clock
**Version:** set by the merge queue at merge
**PR:** 167

## What changed

- `check-reply-prefix.mjs` compares a leading `hh:mm` with the local clock. It takes the shorter way round the day and warns when the difference passes 5 minutes. It logs the miss to `plan/.prefix-misses.log`.
- `RAVINTIO_REPLY_CLOCK` and `RAVINTIO_REPLY_MARGIN_MIN` override the clock and the margin.
- The reply rule in the roadmap standards, both skills, and the boot templates names `date +%H:%M`. `hook-enforcement.md` states the margin.
- Two new suites: `test-0000468-req-001-clock-check.sh` and `test-0000468-req-002-read-the-clock-rule.sh`.
- ADR 0304 records the decision.

## Why

Steps 14, 15, and 19 of initiative 0000360 typed reply times up to an hour off. The hook checked the shape of the time only. Backlog entry 0000434 asked for a check against the clock.

## Deviations

- P2 ran inline without subagents, because the units are small and touch separate files.
- The boot templates use "Take the time from `date +%H:%M`." The longer wording passed the 3800-byte cap by 27 bytes.

## Validation results

- The clock suite fails 8 checks before the change and passes 27 after it. The rule suite fails 8 and passes 8.
- The full suite in a clean clone passes apart from 2 inherited suites.

## Skipped phases

None.
