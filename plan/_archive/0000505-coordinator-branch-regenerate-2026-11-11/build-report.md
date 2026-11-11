# Build report: 0000505-coordinator-branch-regenerate

Run speed: standard

## Phases

| Phase | Agents | Tier | Wall clock (minutes) |
|-------|--------|------|----------------------|
| P0 Discovery | 0 | primary | 1 |
| P1 Plan | 0 | primary | 1 |
| P2 Implement | 0 | primary | 20 |
| P3 Validate and Accept | 0 | primary | 0 |
| P4 Ship | 0 | primary | 7 |

## Parallelism

None used. The run spawned no agents. Each unit was too small to split.

## Self-corrections

- The plan gate allows 3 acceptance criteria for each requirement. I moved the dirty-tree case out of the list. Avoidable: count the criteria while drafting.
- `gate-write` rejected the manifest edit because `component.yml` was not in the design's Component Paths. I added the path. Avoidable: list the manifest in Component Paths when a feature adds a script.
- Two prose-check breaches (passive voice) blocked commits. I rewrote the sentences.

## Improvement suggestions

- P0: add `component.yml` to the Component Paths of every design that adds a script.

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
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 2 | 0 |
