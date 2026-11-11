# Build report: 0000481-regenerate-after-every-merge

Run speed: standard

## Phases

| Phase | Agents | Tier | Wall clock (minutes) |
|-------|--------|------|----------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 0 |
| P2 Implement | 0 | primary | 37 |
| P3 Validate and Accept | 0 | primary | 0 |
| P4 Ship | 0 | primary | 0 |

## Parallelism

None used. The run spawned no agents.

## Self-corrections

- The first edits went to the installed copy `ravintio-zero/`. I moved them to `src/ravintio-zero/`. A scan of the plan paths would have avoided this.
- PR 177 conflicted with the initiative branch twice, and CI did not start. The cause was the conflict, not the CI triggers. The second rework merged the initiative branch after step 44 and renumbered this step's ADR from 0310 to 0313. The first conflict was avoidable. A `mergeable` check before the CI poll now exists (0000483).

## Improvement suggestions

- P4: run `merge-queue.mjs` rehearsal or a `mergeable` read at PR creation, so a conflict shows before CI.

Postmortems: `plan/postmortems/2026-11-11-pr-conflicted-with-initiative-branch.md`

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
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 2 | 0 |
