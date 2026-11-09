---
title: "Build Log - 0000390-prose-checks"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000390-prose-checks

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000390-prose-checks` |
| Pipeline start | `2026-11-09T14:55:27Z` |
| Tool | `claude-code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-09T14:55:27Z` |
| End | `2026-11-09T14:57:47Z` |
| Wall clock | `2` |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | initiative 0000360 step 14 |

- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Run mode: autonomous (2026-11-09T14:55:27Z)
- Migrations 0004, 0005, 0008, 0009 show as pending. Ledger rows exist for 0004 and 0005. 0008 does not apply (`.claude/commands/` holds only `feature-pipeline.md`). 0009 needs the migrator's interactive prompt, and a step session has no human. Left pending, as backlog 0000403 describes.
- Queue: `ci-gate-step-14` read. CI gate rules apply: watch CI before `ready`, restore route if CI fails after archive, write blocks in the build log at line start.
- Scope Lock (happy path): A staged doc with no new breach passes pre-commit and CI [source: draft-accepted (initiative)]
- Scope Lock (first-run path): A repo with no baseline file treats it as empty, and `update --init` writes one [source: draft-accepted (initiative)]
- Scope Lock (error path): A 26-word sentence fails with file and line. A raised baseline fails `diff` [source: draft-accepted (initiative)]
- Scope Lock (cross-session continuity): The baseline lives in git and the session keeps no state [source: draft-accepted (initiative)]
- Scope Lock complete. All four scenario paths captured.
- Version: 0.70.0 to a minor bump (chart row). The merge queue sets the released version.
- Backlog 0000301, 0000303, 0000304 pulled into the brief (2026-11-09T14:57:47Z)
- Baseline failures: clean-clone suite started in the background, recorded before P3.
Complete: P0 (2026-11-09T14:57:47Z)

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-09T15:02:06Z` |
| End | `2026-11-09T15:02:06Z` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Artifacts written inline. The plan set is small and shares one design context, so subagents would only copy it. |

- Decision: the edit pass follows loop-runner mechanics (state file, cap 3, escalation) with no toggle, as the CI loop in the same skill does.
- Decision: the Stop hook runs only when `.claude/output-styles/ravintio-writing.md` exists. No setup flag changes.
- Decision: ADR-0286, ADR-0287, ADR-0288 proposed.
- Consistency check: clean.
Complete: P1 (2026-11-09T15:02:06Z)

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-09T15:26:44Z` |
| End | `2026-11-09T16:27:01Z` |
| Wall clock | `60` |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | `3` |
| MCP calls | `0` |
| Parallel task batches | `1` |
| Notes | U1 inline, U3 to U5 in one parallel batch on sonnet |

- Done: U1 rules module and linter (REQ-001, REQ-002): 38 assertions pass
- Deviation: I wrote the U1 code before its tests. The tests passed on the first run, so U1 shows no RED. U3, U4, and U5 each showed RED first.
- Done: U2 baseline recorded for 377 files
- Done: U3 enforcement points (REQ-003): `commit-msg`, pre-commit, CI `prose` job. One fixture line in `test-commit-msg-hook.sh` reworded from passive to active, assertion unchanged.
- Done: U4 docs edit pass (REQ-004)
- Done: U5 advisory hook (REQ-005). Pins updated for the new hook: hook-filter fixture, shared-module test, advisory command count. `prose-rules.mjs` is not in the Codex copy list because Codex does not use the hook.
- Done: U6 living docs
- Tests run: full suite: 2 inherited failures, 0 new (2026-11-09T16:27:01Z)
- Rework: REQ-003: brand and wording tests read the baseline file, so the allowlists name its ADR and changelog keys (2026-11-09T16:27:01Z)
- Rework: REQ-005: the PowerShell twin of the advisory count pin (2026-11-09T16:27:01Z)
Complete: P2 (2026-11-09T16:27:01Z)

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-09T16:27:01Z` |
| End | `2026-11-09T16:27:01Z` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | `1` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | The docs edit pass ran as one subagent. |

- Docs edit pass: 1 cycle, linter exits 0 on the changed docs
- Baseline check: inherited `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`. New: none.
Complete: P3 (2026-11-09T16:27:01Z)

### P4: Ship

| Field | Value |
|-------|-------|
| Start | `2026-11-09T16:27:01Z` |
| End | `2026-11-09T16:27:01Z` |
| Wall clock | `0` |
| Model tier | primary |
| Skills loaded | ravintio-ship |
| Agents spawned | `0` |
| MCP calls | `0` |
| Parallel task batches | `0` |
| Notes | Initiative step. The merge queue sets the version. |

Complete: P4 (2026-11-09T16:27:12Z)

---

## Summary (filled at ship, P4)

| Metric | Value |
|--------|-------|
| Total phases completed | `5` |
| Total wall clock | `93` |
| Total agents spawned | `4` |
| Total MCP calls | `0` |
| Phases using parallelism | `1` |
| Primary tier agent calls | `4` |
| Cheaper tier agent calls | `0` |
| Self-corrections | `3` |
| Phases skipped | none |

Rework: PR conflicted with the initiative branch after step 10 merged. I merged the branch and renumbered my ADRs to 0286 to 0288. I removed the plan/current files that step 10 left. I fixed three prose breaches from the merge (2026-11-09T16:34:13Z)

Rework: CodeQL flagged the HTML comment regexp in prose-rules.mjs as bad HTML filtering. I replaced it with an indexOf loop (2026-11-09T16:41:27Z)
