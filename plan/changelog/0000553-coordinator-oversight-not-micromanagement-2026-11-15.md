# Changelog (0000553-coordinator-oversight-not-micromanagement, 15 Nov 2026)

**Feature:** Initiative skills do not micromanage
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- The initiative skill no longer tells the coordinator to relay each `I-C Run: activity:` line. It relays watcher lines only at phase events, blocks, and stops.
- The skill tells the coordinator to read step test output only after a stop.
- `test-0000553-req-001-002-oversight.sh` checks both rules. The 0000240 suite pin on the old relay text now expects `Do not relay them`.
- The roadmap standards and `docs/architecture-overview.md` describe the new relay rule.
- The step closes backlog entry 0000530. The OpenTelemetry baseline is out of scope, because that data lives outside the repo.

## Why

The coordinator tracked each step tool call and read step test output that the step already checks. Its context grew while step 55 ran.

## Deviations

None.

## Validation results

- The new suite passes with 6 checks.
- The full suite in a clean clone shows 454 feature suites passed and 3 failed. The 3 failures are the inherited baseline.
- The verification report and security report show no failed criterion and no critical or high finding.

## Skipped phases

None.
