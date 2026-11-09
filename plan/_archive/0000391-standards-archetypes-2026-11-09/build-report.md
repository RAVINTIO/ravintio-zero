# Build report - 0000391-standards-archetypes

Run speed: standard.

## Phases

| Phase | Agents | Tier | Wall clock | Parallel batches |
|-------|--------|------|------------|------------------|
| P0 Discovery | 0 | primary | 2 minutes | 0 |
| P1 Plan | 1 | primary | 5 minutes | 0 |
| P2 Implement | 7 | primary | 52 minutes | 2 |
| P3 Validate | 0 | primary | 21 minutes | 0 |
| P4 Ship | 0 | primary | 22 minutes | 0 |

## Parallelism

Batch 1 ran U1, U4, and U5 together. Batch 2 ran U2, U6, and U7 together. The setup dispatch (U3) ran alone, as the concurrency plan said. U8 and U9 followed. Nothing that could run in parallel ran in sequence.

## Self-corrections

- A sample file used a banned word. The full suite found it. Avoidable with a scan cause for new pack content (backlog 0000415).
- Two test checks diffed against `HEAD` and tested nothing. Avoidable with a testing rule (backlog 0000416).

## Improvement suggestions

- P2: require RED, GREEN, hash, and deviation in every unit report (backlog 0000417).

Postmortems:

- `plan/postmortems/2026-11-09-archetype-content-banned-word.md`
- `plan/postmortems/2026-11-09-test-diffed-against-head.md`

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

Retrospective: `plan/retrospectives/0000391-standards-archetypes-2026-11-09.md`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-005) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| code | primary | 4 | 0 |
| content | primary | 3 | 0 |
| unclassified | unclassified | 2 | 2 |
