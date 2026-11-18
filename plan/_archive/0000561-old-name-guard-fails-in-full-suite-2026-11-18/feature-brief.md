---
title: "Feature Brief - Old-name guard fails in the full suite"
summary: "Make the old-name guard give the same result in a full-suite run and a solo run."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Old-name guard fails in the full suite

**Feature ID:** 0000561-old-name-guard-fails-in-full-suite

## Business Goal

`test-0000189-req-007-old-name-guard.sh` fails in some full-suite runs and passes alone. The hit it prints is on an allowlisted file. A flaky guard hides real failures and costs a rerun. The guard must give one result however the suite runs.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Stable guard | As a maintainer, I run the full suite, so that the old-name guard gives the result it gives alone. | must-have | 1 |
| Planted-change test | As a maintainer, I plant a change like the earlier suite's, so that a test proves the guard ignores it. | must-have | 1 |

## Scope Boundaries

### In Scope
- Find the cause of the full-suite failure by reproduction.
- Make the guard read a stable copy of the tree, or fix the earlier suite that changes it.
- Add a test that plants the earlier suite's change and expects the guard to pass.

### Out of Scope
- Any change to the allowlist or to the old-name pattern.
- Any change to the guard's rule for a planted old name.

### Deferred
- Nothing deferred.

## Acceptance Criteria

- [ ] A full-suite run and a solo run give the same result for the guard suite.
- [ ] A test plants the earlier suite's change and the guard passes.
- [ ] The allowlist keeps its current entries.
- [ ] A planted old name outside the allowlist still fails and names its file and line.
