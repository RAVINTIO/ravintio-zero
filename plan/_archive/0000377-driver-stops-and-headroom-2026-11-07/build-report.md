# Build report - 0000377-driver-stops-and-headroom

Run speed: standard

| Phase | Agents | Tier | Wall clock (min) |
|-------|--------|------|------------------|
| P0 | 0 | primary | 1 |
| P1 | 1 fork | primary | 1 |
| P2 | 1 fork | primary | 28 |
| P3 | 0 | primary | 1 |
| P4 | 0 | primary | see build log |

- Parallelism: none. P1 and P2 each ran in one forked agent, because all three units edit shared files.
- Self-corrections: 0.
- Improvement (P2): the forked agent ended its turn on a background suite run, and the session had to rerun the suite. Wait on the suite in the same turn.
- Postmortems: none
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: none
