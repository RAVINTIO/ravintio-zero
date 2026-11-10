---
title: "Build Report - 0000442-ready-file-helper"
summary: "Build assessment of the ready file helper run."
---
# Build Report - 0000442-ready-file-helper

**Run speed:** standard

## Phases

| Phase | Agents | Model tier | Wall clock (min) |
|-------|--------|-----------|------------------|
| P0 Discovery | 0 | primary | 2 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 4 |
| P3 Validate and Accept | 0 | primary | 58 |
| P4 Ship | 0 | primary | see build log |

## Parallelism

None used. The three P2 units depend on each other, and the P1 artifacts refer to each other. The P3 suites ran in the background while the reports were written.

## Self-corrections

- 1 rework of REQ-001. The test read the file mode with BSD `stat` first, and the Linux CI shard failed. The unit ran the test only on macOS, so it was avoidable. Postmortem: `plan/postmortems/2026-11-10-stat-mode-differs-on-linux.md`.

## Improvement suggestions

- P3: the clean-clone suite takes about 30 minutes on a loaded machine. Run it once, after the last code commit.
- P3: the baseline run at P0 needs a `record` call. The orchestrator start actions say to save the output, but a run can miss the `record` step.

Postmortems: `plan/postmortems/2026-11-10-stat-mode-differs-on-linux.md`

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| code | primary | 2 | 0 |
| content | primary | 1 | 0 |
| unclassified | unclassified | 0 | 1 |
Retrospective: plan/retrospectives/0000442-ready-file-helper-2026-11-10.md
