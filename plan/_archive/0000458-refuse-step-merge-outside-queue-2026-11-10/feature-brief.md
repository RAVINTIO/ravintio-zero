---
title: "Feature Brief - refuse a step merge outside the queue"
summary: "merge-guard refuses a squash merge from a step session that runs under the concurrent driver, so only the merge queue merges a step PR."
status: "approved"
version: "0.1.0"
---
# Feature Brief - refuse a step merge outside the queue

**Feature ID:** 0000458-refuse-step-merge-outside-queue

Source: backlog entry 0000431, from the initiative 0000360 retrospective (evidence row 7).

## Business Goal

Step 12 squash-merged its own PR #133 and bypassed the merge queue. The PR got no version, no tag, and a `pending` chart row. The carve-out lets an agent squash its own PR, and the standard says the queue merges it. `merge-guard` checks only the PR base. The guard now refuses a squash merge when `RAVINTIO_INITIATIVE_QUEUE=1`, which the driver sets for every step session. Only the queue merges a step PR.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Refuse a step merge | As a coordinator, I see `merge-guard` refuse a PR merge from a step session, so that every step PR gets a version, a tag, and a `merged` chart row from the queue. | must-have | 1 |

## Wanted outcome

- `merge-guard` blocks a tripped merge command when `RAVINTIO_INITIATIVE_QUEUE` is `1`, even for a plain squash into `initiative/*`.
- The block message says that the merge queue merges step PRs.
- The carve-out text no longer lets a step session squash its own PR.
- The queue still merges, because it runs as a driver process and not as a session Bash call.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds `merge-guard.mjs`, its tests, and the standards text |

### Data Ownership

No data store.

### Integration Points

The driver sets `RAVINTIO_INITIATIVE_QUEUE=1` in the step session environment. `merge-guard` reads it. No other contract changes.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js hook and Bash tests already in the pack |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A check in `merge-guard.mjs` for `RAVINTIO_INITIATIVE_QUEUE=1`.
- Tests for the refusal and for every path that must still pass.
- Carve-out text in the standards, the ship skill, the invocation reference, `hook-enforcement.md`, and `docs/architecture-overview.md`.
- An ADR, a changelog entry, and the sync of `ravintio-zero/`.

### Out of Scope
- The merge queue script and the driver.
- Coordinator merges, which run without the variable.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Guard strictness | The change only narrows what passes | The pinned test (0000318) still passes unchanged without the variable |

## Constraints and Assumptions

### Constraints
- No new library or service.
- The change narrows the guard and widens nothing.

### Assumptions
- Claude Code passes the session environment to hook processes. Impact if wrong: the guard does not see the variable and allows the merge as it does today. A test covers the variable set.

## Scenario Paths

**Happy path:** a step session with `RAVINTIO_INITIATIVE_QUEUE=1` runs a merge command. The guard blocks it and names the queue.

**Alternative path:** a coordinator session has no variable. A plain squash into `initiative/*` still passes. The queue runs `merge-queue.mjs` in the driver, which holds no hook.

**Error / sad path:** the variable holds `0` or is empty. The guard applies today's rules.

**Cross-session continuity:** not applicable.

## Acceptance Criteria

- [ ] With `RAVINTIO_INITIATIVE_QUEUE=1`, a plain squash merge into `initiative/*` exits 2.
- [ ] Without the variable, the same command exits 0 as before.
- [ ] A test shows that `merge-queue.mjs run` still merges with the variable set in its parent process.
- [ ] The carve-out text names the queue as the only step merge path.
