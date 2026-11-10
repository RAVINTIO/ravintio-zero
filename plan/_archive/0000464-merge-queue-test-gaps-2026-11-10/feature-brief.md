---
title: "Feature Brief - Merge queue test gaps"
summary: "Tests for two untested merge queue branches, and a guard against branch names that start with a dash."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Merge queue test gaps

**Feature ID:** 0000464-merge-queue-test-gaps

## Business Goal

Two branches of `merge-queue.mjs` `run` have no test. A change could break them with no failing check. The script also passes branch names from `gh` to `git` with no check for a leading dash.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Rerun test | As a maintainer, I run the queue twice on one PR, so that I know the second run adds no commit and still merges. | must-have | 1 |
| Mismatch test | As a maintainer, I stub a version file that stays different, so that I know `run` exits 1 before the merge. | must-have | 1 |
| Dash guard | As a maintainer, I want a branch name that starts with a dash refused, so that it never reaches `git` as an option. | should-have | 1 |

## Scope Boundaries

### In Scope
- Two fixtures in one test file for `ravintio-zero/scripts/merge-queue.mjs`.
- A dash check on the branch names `run` reads from `gh pr view`.

### Out of Scope
- Any other change to the queue flow.

## Acceptance Criteria

- [ ] A second `run` on one PR adds no commit to the PR branch and merges.
- [ ] A `version-files.mjs set` that leaves one file different makes `run` exit 1 before the merge.
- [ ] A head or base name that starts with a dash makes `run` exit 1 before any `git` call uses it.
