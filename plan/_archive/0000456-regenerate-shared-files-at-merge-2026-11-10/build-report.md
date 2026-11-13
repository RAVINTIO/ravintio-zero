# Build report - 0000456-regenerate-shared-files-at-merge

Run speed: standard

## Phases

| Phase | Agents | Tier | Wall clock (minutes) |
|-------|--------|------|----------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 2 |
| P2 Implement | 0 | primary | 52 |
| P3 Validate and Accept | 0 | primary | 22 |
| P4 Ship | 0 | primary | 1 |

## Parallelism

None. The units share one file set, so each phase ran inline.

## Self-corrections

None. The P2 block lacked a RED marker for U1, and ship added it from the P2 report.

## Suggestions

- P2: log RED and GREEN markers with the clock as each unit runs.

Postmortems: none

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| unclassified | unclassified | 5 | 0 |

Retrospective: none
