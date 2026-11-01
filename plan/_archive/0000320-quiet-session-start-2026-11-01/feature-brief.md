---
title: "Feature Brief - Quiet session start"
summary: "Session-start hooks and findings speak only when something needs action."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Quiet session start

**Feature ID:** 0000320-quiet-session-start

## Business Goal

Three session-start signals repeat or misfire. The load instruction fires on every prompt, migrations that never apply appear in every finding, and the prefix check warns about replies that have a prefix. A signal that repeats trains the reader to ignore all signals, so this feature makes each one speak only when it needs action.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Once-per-session trigger | As a developer, I see the load instruction once per session, so that I read it when it matters. | must-have | 1 |
| Migration ledger | As a developer, I see a migration finding only while it needs action, and I keep finished migrations outside the pack, so that a pack update does not bring one back. | must-have | 1 |
| Final-reply prefix check | As a developer, I get a prefix warning only when the final reply lacks a prefix, so that I trust the warning. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Hooks, scripts, skills, and migrations |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/state/migrations.md`, `plan/.orchestrator-loaded` | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| Claude Code | hooks | JSON on stdin | `session_id` on every hook, `last_assistant_message` on Stop |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js, built-in modules only |
| Testing | Bash suites, PowerShell parity where a suite already has it |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `auto-trigger-orchestrator.mjs` and `check-orchestrator-presence.mjs`: record the session id and fire once per session.
- `resume-detect.mjs`, the migrator skill, and a migration ledger in `plan/state/migrations.md`, with a new migration that copies `_done/` records into it.
- `check-reply-prefix.mjs`: read `last_assistant_message`.
- Ignore rule and setup wiring for the loaded-session file. Tests, docs, version, changelog.

### Out of Scope
- The pack-version check (entry 0000272).
- Any hook that blocks.

### Deferred
- Other findings with no action. None exist beyond migrations.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Latency | `resume-detect.mjs` finishes inside the hook's 2 second limit | Suite times a run on a repo with 20 ledger rows |
| Security | Hooks print no repo text and never exit 2 | Suite checks exit codes and output |

## Constraints and Assumptions

### Constraints
- Code and docs land together.
- The hooks stay advisory.

### Assumptions
- The host passes `session_id` to `UserPromptSubmit` and `last_assistant_message` to `Stop`. Confirmed in the Claude Code hooks docs on 2026-11-01.

## Scenario Paths

**Happy path:** A session gets the load instruction once, a migration finding appears once per pack version, and a reply with a prefix draws no warning.

**First-run path:** A repo with no ledger or loaded-session file reports as today, and the first report writes the record.

**Error / sad path:** An unreadable ledger or state file reports as today. The prefix hook exits silently when it finds no final reply.

**Cross-session continuity:** The records live outside the pack, so a pack update or a new session reads the same state.

## Acceptance Criteria

- [ ] The first prompt of a session gets the load instruction, a second prompt gets none, and a new session id gets it again.
- [ ] A migration whose condition is false appears once per pack version, a `done` migration stays quiet after a pack update, and a migration whose condition becomes true appears at once.
- [ ] Running a migration changes nothing inside `ravintio-zero/`.
- [ ] A final reply with a prefix after an unprefixed note gives no warning, a final reply without one gives a warning that quotes it, and a missing final reply gives none.
