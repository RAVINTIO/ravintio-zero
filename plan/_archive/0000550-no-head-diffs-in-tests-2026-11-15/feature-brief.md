---
title: "Feature Brief - No HEAD diffs in tests"
summary: "Add a testing rule and a style check that fail any suite diffing the working tree against HEAD."
status: "approved"
version: "0.1.0"
---
# Feature Brief - No HEAD diffs in tests

**Feature ID:** 0000550-no-head-diffs-in-tests

## Business Goal

A test that diffs a file against `HEAD` passes with no change once someone commits the work. Two such checks passed without testing anything in step 15 of initiative 0000360. A style check that fails these suites closes the gap.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| HEAD diff rule | As a test author, I read a rule that bans comparing the working tree with `HEAD`, so that my test keeps its meaning after a commit | must-have | 1 |
| HEAD diff style check | As a maintainer, I run a suite that fails any suite diffing against `HEAD` or a moving ref, so that a vacuous test cannot merge | must-have | 1 |

## Scope Boundaries

### In Scope
- A rule in `ravintio-zero/standards/testing-standards.md`.
- A suite in `ravintio-zero/tests/` that greps suites for a diff against `HEAD`, and a planted case that expects the failure.

### Out of Scope
- Rewriting existing suites that already use `--base HEAD` for a purpose the suite needs.

### Deferred
- Nothing deferred.

## Acceptance Criteria

- [ ] `testing-standards.md` states that a test never compares the working tree with `HEAD` or a moving ref.
- [ ] A suite that diffs against `HEAD` fails the style check.
- [ ] A test plants such a suite and expects the failure.
- [ ] The style check passes on every existing suite, or lists each allowed exception.
