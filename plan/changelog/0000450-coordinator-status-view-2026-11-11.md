# Changelog (0000450-coordinator-status-view, 11 Nov 2026)

**Feature:** Coordinator status view
**Version:** set by the merge queue at merge
**PR:** 0

## What changed

- A new script, `initiative-status.mjs`, prints the driver state, the step counts, each ready PR, each running step, and each live stop. The chart `Status` column decides which steps have merged, and a stop for a merged step does not show.
- `initiative-watch.mjs` reads the chart status. It prints an event for a new `ready` file, a queue stop line in a step log, and a driver exit. Each heartbeat adds `merged {m} of {total}`.
- `initiative-run.mjs` prints the `queue stopped on step {n}` line and its reason at the failure, and appends it to the step log.
- The initiative skill runs the status script before each report and ends each report with `Decisions for you` and `Routine fixes made`.
- `roadmap-standards.md` gains a `#### Status view and events` section.
- Four new suites, `test-0000450-req-001` to `test-0000450-req-004`, cover the script, the watcher, the driver line, and the text.
- ADR 0313 records the decision.

## Why

In initiative 0000360 the coordinator missed a ready line for 24 minutes and a driver exit for two hours. It also gave a wrong status twice, because the watcher read stale control files.

## Deviations

- P2 ran U-1 to U-3 as parallel subagents. The U-2 and U-3 agents wrote code before their suites, then checked the suites against the old code.
- The watcher prints a queue stop line only from a step log it saw on an earlier pass.
- The driver exit report still repeats a stop line that the coordinator cleared. Clearing it is out of scope.

## Validation results

- The new suites pass: 34, 19, 7, and 7 checks.
- The full suite result is in the verification report.

## Skipped phases

None.
