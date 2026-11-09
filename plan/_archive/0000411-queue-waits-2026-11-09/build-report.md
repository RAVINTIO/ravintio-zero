# Build report - 0000411-queue-waits

**Run speed:** fast

| Phase | Wall clock (minutes) | Agents | Model tier | Parallel batches |
|-------|----------------------|--------|------------|------------------|
| P0 Discovery | 0 | 0 | primary | 0 |
| P1 Plan | 1 | 0 | primary | 0 |
| P2 Implement | 6 | 0 | primary | 1 |
| P3 Validate and Accept | 10 | 0 | primary | 0 |
| P4 Ship | 0 | 0 | primary | 0 |

**Parallelism.** None. One requirement in one script.

**Self-corrections.** 1 rework cycle. The test fake answered `gh pr checks` with no JSON, so the suite sat in the CI wait that step 16 had just merged.

**Improvements.**
- P1: reread the files a unit edits at the branch point. Step 16 changed `merge-queue.mjs` between the first read and the branch point.
- P3: the 4-shard local run took about 10 minutes, and one suite flaked under the parallel load.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
