---
title: "Feature Brief - Tests share a repo-root helper for both pack trees"
summary: "A repo_root helper in the test assertion file works from src/ravintio-zero/tests and from ravintio-zero/tests."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Tests share a repo-root helper for both pack trees

**Feature ID:** 0000572-tests-share-a-repo-root-helper

Folded in from backlog entries 0000528 and 0000539.

## Business Goal

The pack keeps two identical trees, and the clean-clone suite runs each test from both. Each suite works out the repo root from its own path. A suite with the wrong depth passes from `src/` and fails from the installed copy. One shared helper removes the gap, and the testing standards tell new suites to use it.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Repo-root helper | As a test author, I call `repo_root` and get the repo top from either tree, so that my suite passes in both. | must-have | 1 |
| Tree path helpers | As a test author, I call helpers that return the source tree and the installed tree, so that I never build a `../..` path. | must-have | 1 |
| Standard and adoption | As a test author, I read in the testing standards that a new suite calls the helper and runs from both trees before it counts as green. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Test helpers, testing standards, and the two suites that adopt the helper |

### Data Ownership

None. The component owns no data.

## Stack

| Concern | Decision |
|---------|----------|
| Language | bash, markdown |
| Testing | bash suites in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- `repo_root`, `pack_tree_src`, and `pack_tree_installed` functions in `helpers/assert.sh`.
- A paragraph in `standards/testing-standards.md` that names the helper and the both-trees rule.
- The two suites named in the postmortem call the helper.
- One new suite that runs the helper from both trees.

### Out of Scope
- Moving every existing suite to the helper.
- A PowerShell twin of the helper.
- Removing the two-tree layout.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Trees | `src/ravintio-zero/` and `ravintio-zero/` hold the same files | `sync-installed.mjs --check` |
| Helper cost | no extra process beyond `pwd` and `cd` | review |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.
- Every suite sources `assert.sh`, so the helper must add no output and no side effect on source.

### Assumptions
- `product.yml` sits at the repo root and nowhere between a suite and the root.

## Scenario Paths

**Happy path:** A suite calls `repo_root` from either tree and gets the same top folder.

> The helper returns the folder that holds `product.yml`.

**First-run path:** No state exists.

> Not applicable.

**Error / sad path:** The helper finds no `product.yml` above the suite.

> It prints nothing and returns 1, so the suite fails loudly.

**Cross-session continuity:** No state is at risk.

> Not applicable.

## Acceptance Criteria

- [ ] `repo_root` returns the repo top when called for a suite in `src/ravintio-zero/tests/` and in `ravintio-zero/tests/`.
- [ ] `pack_tree_src` and `pack_tree_installed` return the two tree paths.
- [ ] `repo_root` returns 1 and prints nothing when no `product.yml` sits above the start folder.
- [ ] The testing standards name the helper and say a new suite runs from both trees before it counts as green.
- [ ] The step-clock and handoff-text suites call the helper and pass from both trees.
