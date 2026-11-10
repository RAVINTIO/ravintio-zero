---
title: "Feature Brief - Smoother activation"
summary: "Activation takes one human confirmation, and each question leads with a recommended plan."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Smoother activation

**Feature ID:** 0000399-smoother-activation

## Business Goal

The human found I-B Activate of initiative 0000360 painful. Questions had no default, a mid-activation step needed hand edits in 10 chart tables, and the suite ran twice. Activation becomes one confirmation with no manual table edits. Source: backlog entry 0000398.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Activate command | As the human, I confirm once, so that the branch, PR, merge, and driver start run in order | must-have | 1 |
| Add-step helper | As the human, I add a step with one command, so that no chart table needs a hand edit | must-have | 1 |
| Question rule | As the human, I see my request restated as one plan with a default, so that I answer "Go?" | must-have | 1 |
| Plan-only PR check | As the human, I skip the full suite when only `plan/` files changed, so that activation does not wait 10 minutes | should-have | 1 |
| Applicable migrations only | As a session, I see a pending line only for a migration that applies, so that findings stay quiet | must-have | 1 |
| Coordinator start-up | As the human, I see the coordinator session load the initiative skill, so that it never loads the orchestrator | should-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The pack. Source in `src/ravintio-zero/`, installed copy in `ravintio-zero/`. |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/current-initiative/initiative.md` chart | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| activate script | `git`, `gh` | CLI | Existing commands only |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node (ESM, no packages) and Bash tests |
| Testing | `ravintio-zero/tests/test-*.sh` |
| CI | GitHub Actions, unchanged |
| Build target | local |

## Scope Boundaries

### In Scope
- Items 1 to 7 of backlog entry 0000398.

### Out of Scope
- A faster full suite.
- Changes to the merge queue or the driver.
- Pending migration 0009 in step sessions (backlog 0000403).

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Human confirmations to activate | 1 | activate test counts prompts |

## Constraints and Assumptions

### Constraints
- No guard gains a new allowed form. The activate script merges only a coordinator PR into `initiative/*`.
- The activate script runs only existing `git` and `gh` commands.

### Assumptions
- The initiative skill starts the driver and the watcher as host background tasks, so the script prints their commands.

## Scenario Paths

**Happy path:** A charted draft exists. The human confirms once. The script cuts and pushes the branch, lands the activation PR, and prints the driver and watcher commands.

> The script exits 0 and the initiative is `active` on the initiative branch.

**First-run path:** No `plan/current-initiative/` exists yet.

> The script creates it from the draft.

**Error / sad path:** A check fails, CI fails, or a push fails.

> The script prints `I-B Activate: Blocked: {reason}` and exits 1 before any later change. It never retries with force.

**Cross-session continuity:** The script stops after the branch push.

> A rerun detects the pushed branch and resumes at the PR step.

## Acceptance Criteria

- [ ] Activating a charted initiative takes one human confirmation and no manual table edits.
- [ ] A test adds a step with `add-step`, and the chart format checks pass on the result.
- [ ] `resume-detect.mjs` prints no line for a migration that does not apply. A test checks this.
- [ ] The initiative skill's question rule names the restate, default, and confirm form, and a skill test pins it.
