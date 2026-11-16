---
title: "Feature Brief - Two open entries share one backlog id"
summary: "backlog-index.mjs --check exits 1 when two backlog entry folders share an id."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Two open entries share one backlog id

**Feature ID:** 0000552-duplicate-backlog-ids

Folded in from backlog entry 0000542.

## Business Goal

Two open entries once shared id 0000476 for three days, because no check reports a duplicate id. CI must fail on the next duplicate, so the coordinator fixes it the same day.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Duplicate id check | As a coordinator, I want `backlog-index.mjs --check` to exit 1 when two entry folders share an id, so that CI fails on the next duplicate. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The index script and its tests |

### Data Ownership

None. The component owns no data.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node (ES modules), bash |
| Testing | bash suites in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- `--check` exits 1 and names each duplicated id on stderr. It checks the index text only when ids are unique.
- One new suite with two folders that share an id.
- Both pack trees, `src/ravintio-zero/` and `ravintio-zero/`.

### Out of Scope
- Duplicate checks in the generate mode and `--review`. The merge queue runs the generate mode before it renumbers, so a failure there stops the renumber.
- Renumbering. No duplicate exists on the base now, so the entry's first action needs no work.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Latency | `--check` adds no I/O beyond the existing scan | Code review |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror each change to `ravintio-zero/`.

### Assumptions
- The merge queue calls the generate mode before `renumberCollisions`. Impact if wrong: the check could also cover the generate mode.

## Acceptance Criteria

- [ ] `--check` exits 1 with a `check:` line that names the id when two folders share it.
- [ ] `--check` exits 0 on unique ids with a current index.
- [ ] The generate mode still writes the index when two folders share an id.
