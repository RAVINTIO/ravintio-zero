---
title: "Feature Brief - Coordinator admin in step PRs"
summary: "Folds admin work into the step PR it aligns with, stops id reservation from committing on the initiative branch, and deletes coordinator branches on merge."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Coordinator admin in step PRs

**Feature ID:** 0000352-coordinator-admin-in-step-prs

## Business Goal

Initiative 0000312 put 13 coordinator squashes between its 10 step squashes. Three rules caused them: queued entries landed by coordinator PR after each step, supervision notes needed a PR per update, and delivery landed in two PRs. This feature tells the coordinator to queue admin work that aligns with a running step so that step commits it in its own PR. It also stops `reserve-id.mjs --commit` from committing on the initiative branch, and it makes every coordinator squash delete its branch.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Queue aligned admin in the step | As a coordinator, I queue admin work that aligns with a running step and name that step, so that the step commits it in its own PR and no coordinator PR lands between steps. | must-have | 1 |
| Step commits the queue | As a step session, I commit the queued items that name my step before P4 raises the PR, so that the squash carries them. | must-have | 1 |
| Unaligned admin by chore PR | As a coordinator, I land admin that fits no step through a `chore/` PR as it happens, so that later steps run on current admin. | should-have | 1 |
| Id reservation refuses on the initiative branch | As a coordinator, I run `reserve-id.mjs --commit` and it refuses on `initiative/*` and names the `feat/` route, so that no direct commit lands. | must-have | 1 |
| Coordinator squash deletes the branch | As a maintainer, I read `gh pr merge --squash --delete-branch {n}` in every coordinator squash instruction, so that no merged coordinator branch stays on `origin`. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, templates, and scripts of the pipeline |

### Data Ownership

None. The feature changes documents and one script. It touches no data store.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| Coordinator | `plan/.initiative-queue/` | file write | One folder per item, with the step named in the item |
| Step session | `plan/.initiative-queue/` | file read | Reads only items that name its step. Never moves, renames, or deletes the folder |
| `reserve-id.mjs` | git | `execFileSync` | Reads the current branch name and refuses `--commit` on `initiative/*` |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM scripts) and Markdown |
| Runtime | Node |
| Testing | Bash test scripts in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- `reserve-id.mjs` refuses `--commit` on a branch that starts with `initiative/`. It exits 1, commits nothing, keeps the reservation behaviour of a run without `--commit`, and names the `feat/` route in its message.
- The roadmap standards, the initiative skill, and the ship skill state the queue rule: admin that aligns with a running step goes in `plan/.initiative-queue/` with the step named, and the step commits it before P4 raises the PR.
- The standards state that admin which fits no step lands through a `chore/` PR as it happens.
- Every coordinator squash instruction in the pack names `--delete-branch`.
- The three skills that call `reserve-id.mjs --commit` name the `feat/` route.
- Tests for each rule.

### Out of Scope
- The reshape script and the `-reshaped` branch (step 3).
- The `chore/*` force-push rule in the ship skill (step 3).
- Driver and watcher changes (step 4).
- Any change to `merge-guard` or another fail-closed hook.

### Deferred
- Rule 3 of entry 0000345 stays in the backlog for step 3.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | The refusal gives the same result for the same branch name | Fixture tests in a scratch repo |

## Constraints and Assumptions

### Constraints
- The change widens no guard. It tightens `reserve-id.mjs`.
- The initiative skill stays under 120 lines.
- A step session never moves, renames, or deletes `plan/.initiative-queue/`.
- Prose follows the writing standard.

### Assumptions
- A queue item is a folder that names its step in a `step:` line. The format is new, so no old item needs conversion.

## Scenario Paths

**Happy path:** The coordinator queues an item with `step: 3` while step 2 runs. Step 3 reads the item at P0, commits it on its feature branch, and the step 3 squash carries it.

> Drafted from the brief. Accepted by the initiative chart.

**First-run path:** An initiative with an empty queue changes nothing. A step finds no item that names it and carries on.

> Drafted from the brief. Accepted by the initiative chart.

**Error / sad path:** `reserve-id.mjs --commit` on `initiative/*` prints the refusal, names the `feat/` route, exits 1, and leaves the counter file and the git history as they were.

> Drafted from the brief. Accepted by the initiative chart.

**Cross-session continuity:** The queue lives on disk, so a step that stops mid-run leaves its items for the resumed session. The script keeps no state.

> Drafted from the brief. Accepted by the initiative chart.

## Acceptance Criteria

- [ ] `reserve-id.mjs --commit` on an `initiative/*` branch exits non-zero, commits nothing, and names the `feat/` route.
- [ ] `reserve-id.mjs --commit` on a `feat/` branch still commits the counter file alone.
- [ ] Every coordinator squash command in the pack names `--delete-branch`.
- [ ] The roadmap standards state the queue rule, the step commit rule, and the `chore/` route for unaligned admin.
- [ ] The initiative skill and the ship skill state the queue rule and stay under their line caps.
- [ ] The skills that call `reserve-id.mjs --commit` name the `feat/` route on `initiative/*`.
