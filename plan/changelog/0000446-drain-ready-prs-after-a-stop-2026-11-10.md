# Changelog (0000446-drain-ready-prs-after-a-stop, 10 Nov 2026)

**Feature:** Merge ready PRs after a stop
**Version:** set by the merge queue at merge
**PR:** 173

## What changed

- The driver keeps queueing ready PRs after one queue failure. Each ready step gets one attempt in a driver run.
- A failed step reads `stopped` in the report and keeps its `ready` file. A new driver queues it again.
- Each failure prints its own `I-D Advance: Blocked: queue stopped on step {n}` line. The first stop line still ends the run.
- `roadmap-standards.md` and the architecture overview state the rule.
- Two new suites, `test-0000446-req-001-drain-after-queue-failure.sh` and `test-0000446-req-002-drain-rule-in-standards.sh`, check the driver and the standards.
- The scheduler fixture accepts a comma list in `QUEUE_FAIL_STEP`.
- `test-0000379-req-004-queue-handoff.sh` now expects step 1 to read `stopped` after a queue failure.
- ADR 0309 records the decision.

## Why

After a queue failure, the driver held back every ready PR. Green PRs for independent steps waited for a human. Backlog entry 0000426 asked for a fix.

## Deviations

- P1 and P2 ran inline without subagents. The work is two small units.

## Validation results

- The full suite passed in the working tree: 408 feature suites and 19 regression suites.
- A clean clone of `HEAD` ran 406 feature suites to a pass. The 2 failures come from the base commit.
- The security review found no critical or high finding.

## Skipped phases

None.
