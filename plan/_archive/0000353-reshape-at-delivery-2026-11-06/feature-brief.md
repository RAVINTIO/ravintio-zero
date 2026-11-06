---
title: "Feature Brief - Reshape at delivery"
summary: "Adds a reshape script that rebuilds an initiative branch as N + 1 titled commits on a new branch, and stops ship from force-pushing chore branches."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Reshape at delivery

**Feature ID:** 0000353-reshape-at-delivery

## Business Goal

Coordinator PRs and admin commits still land on an initiative branch while its steps run. The human wants a delivered branch with one squash per step, then one chore commit. Earlier, the coordinator rewrote the branch in place and force-pushed ten tags. This feature adds a script that builds the reshaped history on a new branch and moves the step tags without a force push. It also removes the `--force-with-lease` allowance for `chore/*` branches from the ship skill.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Reshape script | As a coordinator, I run one script at I-E Delivery and get a new branch with one titled commit per step, then one chore commit, so that the initiative PR shows N + 1 commits. | must-have | 1 |
| Tags move without force | As a coordinator, I move each step tag to its new commit by deleting the old tag on `origin` and pushing a new one, so that no tag is force-pushed. | must-have | 1 |
| Replay conflict stops | As a coordinator, I get a stop that names the commit when a replay conflicts, so that no hunk is dropped. | must-have | 1 |
| Delivery rules name the reshape | As a coordinator, I read the reshape in the I-E Delivery rules and the initiative skill, so that I raise the initiative PR from the reshaped branch. | must-have | 1 |
| Ship drops the chore force push | As a maintainer, I read one route for a multi-commit `chore/*` PR into `main`, the replacement branch, so that no skill allows `--force-with-lease`. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, templates, and scripts of the pipeline |

### Data Ownership

None. The feature adds one script and changes documents. It touches no data store.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `reshape-initiative.mjs` | git | `execFileSync` with argument arrays | Reads the old branch, the chart, and the step tags. Writes a new branch and new tags. |
| `reshape-initiative.mjs` | `check-initiative-history.mjs` | child process | Checks the new branch against the chart |
| Coordinator | `reshape-initiative.mjs` | command line | Runs it at I-E Delivery with the driver stopped |

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
- `ravintio-zero/scripts/reshape-initiative.mjs`. It reads the chart, finds each step commit through its version tag, and replays each step diff in chart order onto the base the branch was cut from. It folds the admin commits that the coordinator assigns to a step into that step. It adds one chore commit whose tree equals the old head. It writes a new branch named `{branch}-reshaped`.
- The script moves the step tags to the new step commits on request. It deletes the old tag and creates a tag with the same name and message. With a push option it pushes the branch and the tags, and deletes the old tags on `origin` by a delete refspec.
- A replay conflict exits 1, names the commit, and changes nothing else.
- No command in the script uses `--force` or `-f`.
- The I-E Delivery rules and the initiative skill state the reshape procedure and the cleanup: close any PR from the old branch and delete the old branch after the human merges.
- The ship skill's `## PRs into main` drops the `chore/*` `--force-with-lease` allowance and applies the `hotfix/*` route to `chore/*`.
- Tests for each rule.

### Out of Scope
- Driver and watcher changes (step 4).
- Any change to `merge-guard` or another fail-closed hook.
- Pushing or deleting branches on `origin` from the script. The coordinator deletes the old branch after the human merges.

### Deferred
- None. Entry 0000345 is complete once this step ships.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | The same fixture gives the same tree and the same commit subjects | Fixture tests in a scratch repo |

## Constraints and Assumptions

### Constraints
- The change widens no guard. The script runs no force push, no `reset`, and no `checkout`, and it never writes to the working tree of the caller.
- The initiative skill stays under 120 lines.
- Prose follows the writing standard.

### Assumptions
- Each merged step has a tag `v{Version}` from the chart `Version` column, and the tag points at the step squash. Step tags that differ stop the script.
- An old step commit subject ends with ` (#{n})`. The script keeps that number in the new step title.

## Scenario Paths

**Happy path:** A fixture branch holds an activation commit, three step squashes with tags, and one coordinator commit. The script writes `{branch}-reshaped` with three titled step commits and one chore commit. The last tree equals the old head, and each tag points at its new step commit.

> Drafted from the brief. Accepted by the initiative chart.

**First-run path:** A branch whose history already matches N + 1 commits reshapes to the same trees. The script adds no chore commit when the last step tree equals the old head.

> Drafted from the brief. Accepted by the initiative chart.

**Error / sad path:** A replay that conflicts exits 1, names the commit, writes no branch, and moves no tag. A missing tag exits 1 and names the step. A target branch that exists exits 1.

> Drafted from the brief. Accepted by the initiative chart.

**Cross-session continuity:** The script keeps no state. The branch and the tags on disk hold the result, so a coordinator that stops mid-delivery reads the new branch and carries on.

> Drafted from the brief. Accepted by the initiative chart.

## Acceptance Criteria

- [ ] On a fixture branch, the script writes a new branch with N + 1 commits. The last tree equals the old head.
- [ ] With the tag option, every step tag points at its new step commit and keeps its message.
- [ ] A conflicting replay exits 1, names the commit, and writes no branch.
- [ ] `check-initiative-history.mjs` passes on the new branch.
- [ ] No command in the script uses `--force` or `-f`.
- [ ] The I-E Delivery rules and the initiative skill name the reshape, the tag move, and the old branch cleanup. The initiative skill stays under 120 lines.
- [ ] The ship skill names no `--force-with-lease`. A multi-commit `chore/*` PR uses the replacement branch route.
