# Build report - 0000420-version-both-copies

**Run speed:** fast

| Phase | Wall clock (minutes) | Agents | Model tier | Parallel batches |
|-------|----------------------|--------|------------|------------------|
| P0 Discovery | 0 | 0 | primary | 0 |
| P1 Plan | 2 | 0 | primary | 0 |
| P2 Implement | 3 | 0 | primary | 1 |
| P3 Validate and Accept | 9 | 0 | primary | 0 |
| P4 Ship | 0 | 0 | primary | 0 |

**Parallelism.** None. One requirement.

**Self-corrections.** 0 rework cycles.

**Improvements.**
- P2: a JavaScript `replace` with `$'` in the new text copied the rest of a test file. Use the Edit tool for test edits.
- P0: the new prose hook rejects long sentences in plan files. Write short sentences from the start.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
