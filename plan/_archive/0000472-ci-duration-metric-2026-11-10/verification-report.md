---
title: "Verification Report - 0000472-ci-duration-metric"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000472-ci-duration-metric

Method: ran `workflow-metrics.mjs` on build logs that hold markers, on this run's own build log, and ran the two new suites. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 longest run row | Ran the script on a log with markers of 281 and 450 seconds | verified | The row read `Longest CI run (seconds) \| 450 (run 9002) \| 420 \| breach`. The suite checks the 280 and 310 case and passes |
| REQ-001 AC-2 breach | Same run | verified | The exit code was 0 with a breach in the report |
| REQ-001 AC-3 no marker | Ran the script on `plan/current/` | verified | The row read `0 \| 420 \| ok` |
| REQ-002 AC-1 governance standard | Read the standard and ran the script against it | verified | The marker, the `ci-duration-seconds` key, and the threshold 420 are present. The script read the table with exit 0 |
| REQ-002 AC-2 CI target | Read `testing-standards.md` | verified | It names the CI duration target of 420 seconds |
| REQ-002 AC-3 ship marker | Read the ship skill | verified | It names `gh run view` and the `CI duration:` marker |
