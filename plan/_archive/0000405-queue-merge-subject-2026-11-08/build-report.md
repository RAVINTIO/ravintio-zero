# Build report - 0000405-queue-merge-subject

**Run speed:** fast

| Phase | Wall clock (minutes) | Agents | Model tier | Parallel batches |
|-------|----------------------|--------|------------|------------------|
| P0 Discovery | 77 | 0 | primary | 0 |
| P1 Plan | 0 | 0 | primary | 0 |
| P2 Implement | 17 | 0 | primary | 1 |
| P3 Validate and Accept | 0 | 0 | primary | 0 |
| P4 Ship | 0 | 0 | primary | 0 |

**Parallelism.** None. One requirement and a one-line fix, so I ran it inline.

**Self-corrections.** 0 rework cycles.

**Improvements.**
- P0: most of the 77 minutes was a wait for the human, who was away from the laptop.
- P2 and P3: the full suite takes over 10 minutes. `test-0000042-req-006` and `test-0000043-req-009` fail while step worktrees exist, so each run needs a clean-clone check.
- P4: the `merge-guard` hook blocks any command that names a merge in text, including a heredoc that writes a test. Write such files with the Write tool.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
