# Build report: 0000474-coordinator-shell-guidance

Run speed: standard

## Phases

| Phase | Agents | Tier | Wall clock (minutes) |
|-------|--------|------|----------------------|
| P0 Discovery | 0 | primary | 3 |
| P1 Plan | 0 | primary | 2 |
| P2 Implement | 0 | primary | 34 |
| P3 Validate and Accept | 1 | primary | 2 |
| P4 Ship | 0 | primary | 8 |

## Parallelism

- P2 ran the full suite as 4 parallel shards.
- P3 used one subagent for the docs edit pass.
- Every implementation unit was too small to split, so they ran inline.

## Self-corrections

- The first full-suite run used the installed-copy runner. One suite read paths relative to `src/` and failed. I reran from `src/ravintio-zero/tests/run-tests.sh`, as CI does. Avoidable: use the source runner from the start.
- Three shards hit the 10-minute background limit. I reran them with the longest timeout. Avoidable: set the timeout when I start a background suite.
- The PR conflicted with the initiative branch after another step merged. I merged the base, resolved the shared files, and renumbered ADR 0316 to 0317. Avoidable: reserve the ADR number after the final base merge.
- Prose-check blocked five commits for long sentences, a blocklist word, and passive voice. I rewrote each sentence.

## Improvement suggestions

- P2: run the suite from `src/ravintio-zero/tests/run-tests.sh` and say so in the plan's test impact table.
- P4: rebase on the base before `gh pr create`, so the PR starts mergeable.

Postmortems: none

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

Retrospective: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 315 (run 42980839117) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 5 | 0 |
