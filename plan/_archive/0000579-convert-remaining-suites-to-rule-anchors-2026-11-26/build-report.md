# Build report - 0000579-convert-remaining-suites-to-rule-anchors

**Run speed:** fast

## Phases

| Phase | Agents | Tier | Wall clock (minutes) | Parallel batches |
|-------|--------|------|----------------------|------------------|
| P0 Discovery | 0 | primary | 3 | 0 |
| P1 Plan | 0 | primary | 1 | 0 |
| P2 Implement | 8 | primary | 49 | 2 |
| P3 Validate and Accept | 0 | primary | 24 | 0 |
| P4 Ship | 0 | primary | 1 | 0 |

## Parallelism

- P2 ran seven conversion agents in one batch, then one agent for the second roadmap part. The second part waited for the first, because both anchor rules in the roadmap standards.
- P3 ran the full suite in the background while the reports were written.
- No multi-task phase ran sequentially without a reason.

## Self-corrections

| Correction | Avoidable |
|------------|-----------|
| Byte caps on the orchestrator `SKILL.md` counted anchors. Five suites and one PowerShell suite now count the text without them. | Yes. The plan scan has no cause for edits that add bytes. Entry 0000606 files it. |
| Boot templates carried anchors that setup copies into installs. The step removed them and four suites use plain checks. | Yes. Same gap. |
| `test-0000016-pipeline-governance.sh` lost an assertion line, and the ratchet compares its count with the regression copy. The step restored the original. | Yes. Same gap. |
| `test-0000036-req-001-003-runner.sh` found the ledger file as undiscovered. The step listed it in `run-tests.sh`. | Yes. A new tests file needs a runner list row. |

## Improvement suggestions

- P1: add a plan scan cause for anchor edits (0000606).
- P2: brief each batch agent on caps, installed copies, and ratchets before it edits shared files.
- P3: none.

Postmortems: `plan/postmortems/2026-11-26-anchor-edits-broke-cap-and-copy-consumers.md`

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

These three failures predate the step. The pack already tracks them for repair.
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 3 (REQ-001) | 2 | breach |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 1. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| config | inline | 1 | 0 |
| content | inline | 1 | 0 |
| test | inline | 1 | 0 |
| test | primary | 7 | 0 |
| unclassified | unclassified | 0 | 3 |
