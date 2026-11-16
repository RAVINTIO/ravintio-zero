# Build report - 0000575-build-log-marker-helper

Run speed: fast

| Phase | Agents | Tier | Wall clock |
|-------|--------|------|------------|
| P0 Discovery | 0 | primary | 1 min |
| P1 Plan | 0 | primary | 1 min |
| P2 Implement | 0 | primary | 50 min |
| P3 Validate | 0 | primary | 0 min |
| P4 Ship | 0 | primary | 0 min |

- Parallelism: none used. The three units were small, so the agent ran them inline. P2 waited on the full suite for most of its wall clock.
- Self-corrections: 0.
- Improvement: start the baseline suite and the P2 full suite as one run, because both took about 20 minutes.
- Postmortems: none
- Inherited failures:
  - `test-0000037-req-004-remove-old-folder.sh`
  - `test-0000318-req-004-merge-guard-pinned.sh`
  - `test-0000450-req-004-report-format.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| code | inline | 1 | 0 |
| content | inline | 2 | 0 |

Retrospective: none
