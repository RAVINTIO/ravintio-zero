---
title: "Feature Brief - Merge-time versioning"
summary: "A serial merge queue sets each step's version when its PR merges, checks the PR title, and checks every version file."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Merge-time versioning

**Feature ID:** 0000378-merge-time-versioning

## Business Goal

Steps that run at once cannot each compute a version in P4, because two steps cut from the same head would pick the same version. This feature moves version work into a serial merge queue so each version and tag follows merge order. It also closes three gaps that the queue needs: a PR title check, a version file check, and a reshape that follows merge order and folds admin commits.

Backlog entries pulled in: 0000374, 0000376, 0000372, 0000368. Initiative step 2 of 21.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Version file list and check | As a maintainer, I list the version files once, so that the bump and the check read the same list. | must-have | 1 |
| Step PR title check | As a coordinator, I check a step PR title against the chart before the merge, so that the squash commit matches the history check. | must-have | 1 |
| Merge queue | As a coordinator, I merge one ready step PR at a time with its version set at merge, so that versions follow merge order. | must-have | 1 |
| Merge-order history | As a coordinator, I reshape and check a branch whose steps merged out of chart order, so that delivery passes. | must-have | 1 |
| Reshape folds | As a coordinator, I reshape a branch with admin commits that a later step builds on, so that delivery needs no human for a fold that clears the conflict. | should-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Scripts, standards, skills, and tests for the pipeline |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/current-initiative/initiative.md` chart | ravintio-zero | none |
| `ravintio-zero/version-files.txt` | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| merge queue | GitHub | `gh` CLI | `gh pr view`, `gh pr checks`, `gh pr merge --squash --delete-branch` |
| merge queue | git | `git` CLI | merge, tag, push without force |

## Stack

| Concern | Decision |
|---------|----------|
| Language | JavaScript (Node ESM, no packages) and Bash |
| Runtime | Node |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Bash suites under `ravintio-zero/tests/` |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `version-files.txt` and `version-files.mjs` with `check` and `set`.
- `merge-queue.mjs` with `title`, `versions`, and `run`.
- `reshape-initiative.mjs` and `check-initiative-history.mjs` ordering by merge order.
- Reshape folds of admin commits.
- Docs: roadmap standards, ship skill, initiative skill, component manifest.

### Out of Scope
- Wiring the driver to call the merge queue and removing the P4 bump. Step 3 does it, as the chart decisions say.
- Parallel steps, worktrees, and the `Lane` and `After` columns.
- Tightening `merge-guard`.

### Deferred
- Removing the P4 version edits is blocked until step 3 moves the driver to the queue.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Dependencies | zero new packages | `ravintio-zero/` holds no `package.json` change |
| Test time | each new suite finishes in under 60 s | suite wall clock |
| Safety | no force push, no shell string built from input | tests and review |

## Constraints and Assumptions

### Constraints
- Steps 1 and 2 keep today's P4 bump. The queue sets versions from step 3.
- The squash title form is `{feature-id}: {Title} (#{n})` with the 7-digit id.
- The orchestrator skill has no byte headroom for new text.

### Assumptions
- Tags `v{Version}` exist for merged steps, as I-D Advance creates them.

## Scenario Paths

**Happy path:** Two ready step PRs sit in reverse chart order. The queue merges the first ready PR, sets the next version, tags the merge commit, then does the same for the second. Versions are consecutive in merge order.

**First-run path:** The chart has no merge record yet and no step has a version. The queue starts from the version on the initiative branch.

**Error / sad path:** A PR title holds the slug, a version file differs after the bump, or CI fails. The queue stops with a named error and merges nothing.

**Cross-session continuity:** The queue writes the version and chart row onto the PR branch before the merge. If it stops, the PR branch holds those commits and a rerun finds them already applied.

## Acceptance Criteria

- [ ] Two fixture steps that merge in reverse chart order get consecutive versions in merge order, each tag at its step's merge commit.
- [ ] A mismatched title or a version file that differs stops the queue before the merge.
- [ ] The reshape and the history check pass on a branch whose steps merged out of chart order.
- [ ] A fixture where step 1 edits a file that the activation commit creates reshapes with no `--assign` and names the fold.
- [ ] A conflict that no fold clears exits 1 and names the commit.
