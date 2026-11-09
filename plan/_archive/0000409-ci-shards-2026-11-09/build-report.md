# Build report - 0000409-ci-shards

**Run speed:** fast

| Phase | Wall clock (minutes) | Agents | Model tier | Parallel batches |
|-------|----------------------|--------|------------|------------------|
| P0 Discovery | 0 | 0 | primary | 0 |
| P1 Plan | 3 | 0 | primary | 1 |
| P2 Implement | 5 | 0 | primary | 2 |
| P3 Validate and Accept | 25 | 0 | primary | 0 |
| P4 Ship | 0 | 0 | primary | 0 |

**Parallelism.** None. The two units share the workflow file, and U-002 depends on U-001.

**Self-corrections.** 2 rework cycles. A test expected two suites in shard 3 of 3, where five suites give one. The first CI run took 7m23s on one Windows shard, so the Windows matrix grew from 3 shards to 4.

**Improvements.**
- P3: most of the 25 minutes went on two CI runs and a full local suite. The local suite ran in 4 shards with `RAVINTIO_SHARD`, which took about 10 minutes.
- P2: `gate-write` blocks shell writes to files outside the repo, such as memory files. Use the Write tool for those.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 1 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
