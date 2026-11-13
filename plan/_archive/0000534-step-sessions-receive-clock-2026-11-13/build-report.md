# Build Report - 0000534-step-sessions-receive-clock

**Run speed:** standard

## Phases

| Phase | Wall clock (minutes) | Agents | Model tier | Notes |
|-------|----------------------|--------|-----------|-------|
| P0 Discovery | 4 | 0 | primary | One proof `claude -p` session on a cheaper model |
| P1 Plan | 2 | 0 | primary | Artifacts written inline |
| P2 Implement | 35 | 0 | primary | Most of the time was the full suite |
| P3 Validate and Accept | 25 | 1 | primary | One docs edit subagent. The clean-clone run took about 25 minutes. |
| P4 Ship | 0 | 0 | primary | The log records 0 minutes. CI took 299 seconds. |

## Parallelism

- The agent ran no phase in parallel. The units share one script, one helper, and one test file, so it ran each inline.
- The clean-clone suite ran in the background while the agent wrote the reports.

## Self-corrections

- 1 in P2. The new test found the repo root at the source depth, so the installed copy failed. It was avoidable: the agent ran the test from `src/` only. The postmortem is `plan/postmortems/2026-11-13-installed-copy-repo-root.md`.

## Improvement suggestions

- P2: run the new test from the installed copy before the full suite. Backlog entry 0000539 asks for a shared repo root helper.
- P3: two full clean-clone runs cost about 40 minutes. A faster affected-suite run after a test fix would save one of them.

Postmortems: plan/postmortems/2026-11-13-installed-copy-repo-root.md

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-003) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 299 (run 43372213435) | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 4 | 0 |
| unclassified | unclassified | 0 | 1 |
Retrospective: plan/retrospectives/0000534-step-sessions-receive-clock-2026-11-13.md
