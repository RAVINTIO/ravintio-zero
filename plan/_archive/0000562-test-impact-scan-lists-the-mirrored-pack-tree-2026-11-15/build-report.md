# Build report - 0000562

**Run speed:** fast

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 145 |
| P3 Validate and Accept | 0 | primary | 649 |
| P4 Ship | 0 | primary | see build log |

P3 wall clock includes the wait for the first full-suite attempt, which stopped at the time limit under load. P2 includes a pause before P3.

## Parallelism

None used. Every unit was a text change, so the units ran inline.

## Self-corrections

- REQ-001, three suites pinned the scan in `SKILL.md`. Avoidable. P1 could have listed them in the test impact table.
- REQ-001, `test-0000171-req-004-no-skill-bundling` asserted that `ravintio-plan/references` is absent. Avoidable. The local full run showed the failure and the step read it as inherited. CI found it.

## Improvements

- P1: list suites that pin text or folders the step moves.
- P3: compare each failed suite with the chart's known baseline failures before calling it inherited.

## Postmortems

- `plan/postmortems/2026-11-15-clean-clone-suite-did-not-finish.md`
- `plan/postmortems/2026-11-15-scan-moved-to-reference-file.md`

Inherited failures: none recorded. The chart lists `test-0000037`, `test-0000318`, and `test-0000450` as base failures.
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 2 (REQ-001) | 2 | ok |
| `Blocked:` stops | 1 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 480 (run 43716886516) | 420 | breach |

Breaches: 1. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 2 | 0 |
| unclassified | unclassified | 0 | 2 |
Retrospective: plan/retrospectives/0000562-test-impact-scan-lists-the-mirrored-pack-tree-2026-11-15.md
