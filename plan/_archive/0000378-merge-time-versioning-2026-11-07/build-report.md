# Build report - 0000378-merge-time-versioning

Run speed: standard. Run mode: autonomous (initiative step 2 of 21).

## Phases

| Phase | Agents | Model tier | Wall clock (min) | Parallel batches |
|-------|--------|-----------|------------------|------------------|
| P0 Discovery | 0 | primary | 2 | 0 |
| P1 Plan | 0 | primary | 2 | 0 |
| P2 Implement | 4 | primary | 19 | 2 |
| P3 Validate and Accept | 0 | primary | 1 | 0 |
| P4 Ship | 0 | primary | 0 | 0 |

Total wall clock to the P4 End: 24 minutes.

## Parallelism

- P2 ran U1 with U3, then U2 with U4, as the concurrency plan set. U2 started as soon as U1 finished. U5 (docs) ran inline while U4 worked.
- P1 wrote its artifacts one at a time inline, although the requirement files were independent. The plan skill says to parallelise them.

## Self-corrections

- 0 in P3.
- 1 rework in P2: REQ-005 changed the req-003 AC-1 fixture of an older reshape suite, because the new fold cleared the conflict that fixture relied on. It was unavoidable.

## Improvement suggestions

- P1: dispatch independent requirement files in parallel.
- P2: ask each unit's brief to include the tests for rerun-safety and the post-set version check in `merge-queue.mjs run`. Both branches have no test.
- P2: stage by explicit path. A `git add -A` for the docs commit staged a running agent's files and needed an unstage.
- P4: the installed ship skill under `.claude/skills` is stale until the coordinator reruns setup at the `Setup:` stop.

Postmortems: none
