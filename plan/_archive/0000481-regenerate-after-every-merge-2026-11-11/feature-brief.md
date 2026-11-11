---
title: "Feature Brief - Regenerate shared files after every base merge"
summary: "The merge queue regenerates shared files after every base merge, clean or not."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Regenerate shared files after every base merge

**Feature ID:** 0000481-regenerate-after-every-merge

## Business Goal

On 2026-11-10 a clean base merge into PR #171 left `plan/backlog/index.md` stale. CI `validate-branch` failed and the queue stopped. The queue must keep shared files current after every base merge so no step PR stops for a stale generated file.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Regenerate after every base merge | As the merge queue, I regenerate the backlog index and check the counters after each base merge, so that CI never fails on a stale shared file. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | `shared-files.mjs` and `merge-queue.mjs` |

### Data Ownership

No data store changes.

## Scope Boundaries

### In Scope
- A regeneration function in `shared-files.mjs` that runs after every base merge.
- A queue call that commits any change before the push.
- Tests, docs, and the roadmap standards text.

### Out of Scope
- New shared files. The allowlist stays as it is.
- Any change to conflict resolution.

### Deferred
- None.

## Constraints and Assumptions

### Constraints
- The queue treats file text as data and passes git arguments as arrays.

### Assumptions
- `backlog-index.mjs` is deterministic on a fixed set of entries.

## Acceptance Criteria

- [ ] After a clean base merge that leaves `plan/backlog/index.md` stale, the queue commits a regenerated index before it pushes.
- [ ] If nothing changes, the queue adds no commit.
- [ ] `plan/backlog/.next-id` and `docs/adr/.next-id` never fall below the higher parent value after a base merge.
- [ ] A conflicting base merge still resolves as before and then regenerates.
