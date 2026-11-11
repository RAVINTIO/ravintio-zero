---
title: "Build Log - 0000519-ship-removal-needs-human-approval"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000519-ship-removal-needs-human-approval

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000519-ship-removal-needs-human-approval` |
| Pipeline start | `2026-11-11T08:41:41Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-11T08:41:41Z` |
| End | `2026-11-11T08:42:30Z` |
| Wall clock | `2` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Initiative 0000360 step 58. Migration 0009 stays pending: it needs a y/n answer and a step session has no human. |

- Adoption mode: standard-iterative (signal: plan/_archive/ holds prior runs)
- Run mode: autonomous (2026-11-11T08:41:41Z)
- Run speed: standard
- Queue: `plan/.initiative-queue/` does not exist. No item names step 58.
- Backlog pickup: 0000518-ship-removal-needs-human-approval pulled in, folder deleted, index regenerated.
- Baseline: `clean-clone-test.mjs` started in the background at 2026-11-11T08:40:50Z, output in `/tmp/step58-baseline.txt`.
- Decisions: none name step 58
- Scope Lock (happy path): ship copies plan/current/ to the archive, runs git rm -r -q plan/current, and continues [source: draft-accepted (initiative)].
- Scope Lock (first-run path): a step that never shipped reads the command from the skill text [source: draft-accepted (initiative)].
- Scope Lock (error path): if the removal fails, the step prints Blocked with the exact error and stops [source: draft-accepted (initiative)].
- Scope Lock (cross-session continuity): the archive copy exists before the removal, so a resumed session restores plan/current/ from it [source: draft-accepted (initiative)].
- Scope Lock complete. All four scenario paths captured.
- Design confirmed: draft-accepted (initiative) (2026-11-11T08:42:30Z)

Complete: P0 (2026-11-11T08:42:30Z)

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-11T08:42:55Z` |
| End | `2026-11-11T08:43:46Z` |
| Wall clock | `1` |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Two requirements, one ADR (0319). Inline, because the units are small. |

Complete: P1 (2026-11-11T08:43:46Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-11T08:44:00Z` |
| End | `2026-11-11T09:46:57Z` |
| Wall clock | `63` |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Two units ran inline, because they are small and edit separate files. The full suite took about 60 minutes because other steps shared the machine. |

- RED: U-1 (2026-11-11T08:44:24Z)
- RED: U-2 (2026-11-11T08:44:24Z)
- GREEN: U-1 (2026-11-11T08:45:30Z)
- GREEN: U-2 (2026-11-11T08:45:30Z)
- Done: U-1 (content, inline, none, 2026-11-11T08:45:30Z)
- Done: U-2 (content, inline, none, 2026-11-11T08:45:30Z)
- Tests run: REQ-001: src/ravintio-zero/tests/test-0000519-req-001-ship-removal-command.sh, test-0000025-req-002-ship-agent-p7-git-add.sh (2026-11-11T08:45:30Z)
- Tests run: REQ-002: src/ravintio-zero/tests/test-0000519-req-002-p2-docs-timing.sh, test-0000385-req-001-affected-tests.sh (2026-11-11T08:45:30Z)
- Tests run: full suite: 431 passed, 2 failed (2026-11-11T09:46:57Z)
- Rework: REQ-001: the installed-copy check used a root that fails for the installed copy of the suite (2026-11-11T09:46:57Z)
- Note: the GREEN times are approximate, written after the runs. The two failures were `test-0000450-req-004-report-format.sh`, which fails in the baseline, and the Rework suite, which passes after the fix.
- Baseline: 3 inherited failing suites, recorded in `plan/current/baseline-failures.md`.

Complete: P2 (2026-11-11T09:46:57Z)

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-11T09:47:04Z` |
| End | `2026-11-11T10:09:20Z` |
| Wall clock | `22` |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | `1` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | One self-correction (the req-001 root path), logged in P2. The clean-clone suite ran in the background while the reports were written. OS gap: local macos, CI ubuntu, windows |

- Tests run: full suite: 430 passed, 3 failed (clean clone, 2026-11-11T10:09:20Z)
- Baseline: 3 inherited suites, 0 new.
- Docs edit pass: 1 cycle, 1 change (one sentence split), prose-check exit 0.
- Security: 0 critical or high findings.

Complete: P3 (2026-11-11T10:09:20Z)

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | `{{count}}` |
| Total wall clock | `{{minutes from pipeline start to the P4 End}}` |
| Total agents spawned | `{{count}}` |
| Total MCP calls | `{{count}}` |
| Phases using parallelism | `{{count}}` |
| Primary tier agent calls | `{{count}}` |
| Cheaper tier agent calls | `{{count}}` |
| Self-corrections | `{{count}}` |
| Phases skipped | `{{list or "none"}}` |
