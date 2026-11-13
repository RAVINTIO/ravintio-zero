# Build report - 0000446-drain-ready-prs-after-a-stop

Run speed: standard

## Phases

| Phase | Wall clock (min) | Agents | Model tier |
|-------|------------------|--------|------------|
| P0 Discovery | 2 | 0 | primary |
| P1 Plan | 1 | 0 | primary |
| P2 Implement | 25 | 0 | primary |
| P3 Validate and Accept | 20 | 0 | primary |
| P4 Ship | 7 | 0 | primary |

## Parallelism

- No phase used subagents. The units are small, and the code unit edits one function.
- The baseline run and the full suite ran in the background while work continued.

## Self-corrections

- 0 in P3. Two prose-check breaches blocked commits at P0 and P2. Each was avoidable with a prose check before the commit.

## Improvement suggestions

- P0: run `prose-check.mjs check` on the design and brief before the first commit.
- P3: the clean-clone suite takes about 20 minutes. Start it as soon as P2 closes.

Postmortems: none
Inherited failures:
- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 332 (run 42929192672) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 4 | 0 |

Retrospective: none
