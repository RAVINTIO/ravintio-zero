# Changelog (0000472-ci-duration-metric, 10 Nov 2026)

**Feature:** CI duration metric
**Version:** set by the merge queue at merge
**PR:** 172

## What changed

- Ship appends `CI duration: {seconds}s (run {run-id}, {timestamp})` to the build log when the CI wait ends. It reads the run with `gh run view`.
- `workflow-metrics.mjs` gains a fifth row, `Longest CI run (seconds)`. It shows the highest marker and its run id against the threshold `ci-duration-seconds`. A log with no marker shows `0` and `ok`.
- `workflow-governance-standards.md` defines the marker and holds the threshold row of 420 seconds.
- `testing-standards.md` names the CI duration target of 420 seconds.
- Two new suites, `test-0000472-req-001-ci-duration-metric.sh` and `test-0000472-req-002-ci-duration-standards.sh`, check the row and the standards.
- `test-0000173-req-002-thresholds-gate.sh` writes the new key into its custom standards files.
- ADR 0308 records the decision.

## Why

Each merge in initiative 0000360 waited about 16 minutes for CI. Feature 0000409 cut it to 4m40s. No metric showed CI growth, so it showed only when someone felt it. Backlog entry 0000436 asked for a metric and a target.

## Deviations

- P2 ran inline without subagents, because the work is two small units.
- The plan holds two requirements. The design named one, so the design's skill map now lists both.
- The initiative branch moved during P3. The step merged it and regenerated `plan/backlog/index.md`.

## Validation results

- The new suites passed 3 of 7 and 0 of 6 checks before the change, and 7 of 7 and 6 of 6 after it.
- The full suite in a clean clone passes 402 and fails 2 suites, both inherited. The regression suite passes 19.

## Skipped phases

None.
