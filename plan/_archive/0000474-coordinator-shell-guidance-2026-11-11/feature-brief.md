---
title: "Feature Brief - Coordinator shell guidance"
summary: "Standards text and scripts that stop the coordinator losing time to zsh and guard snags."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Coordinator shell guidance

**Feature ID:** 0000474-coordinator-shell-guidance

## Business Goal

From 2026-11-08 to 2026-11-10 shell snags cost the coordinator time. zsh does not split `set -- $x`. zsh reads `$b:r` as a modifier. A JavaScript `replace` with `$'` duplicated a test file. `merge-guard` and `block-forced-add` blocked compound and variable commands. Build reports from 0000316, 0000317, and 0000405 give the same advice, but it never reached a standard. The coordinator needs written guidance and ready scripts for the repeated tasks.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Coordinator shell guidance | As the coordinator, I read one section that names bash and tells me to write scripts with the Write tool, so that zsh and guard snags stop costing time. | must-have | 1 |
| Coordinator task scripts | As the coordinator, I run a script for the queue drain, the overlap check, and bulk edits, so that I never improvise a compound command. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Initiative skill, roadmap standards, and coordinator scripts |

### Data Ownership

No data store changes.

## Scope Boundaries

### In Scope
- A coordinator section in the roadmap standards that names bash and says to write scripts with the Write tool.
- A pointer to that section in the initiative skill.
- Scripts for the queue drain, the overlap check, and bulk edits, where no script exists yet.
- Tests and docs.

### Out of Scope
- Any change to `merge-guard` or `block-forced-add`. They must not allow variables, compound commands, or quoting.

### Deferred
- None.

## Constraints and Assumptions

### Constraints
- Git calls take argument arrays. The scripts treat file text as data.
- The initiative skill stays under its size cap.

### Assumptions
- `coordinator-pr-check.mjs` already covers the overlap check, so the change reuses it.

## Acceptance Criteria

- [ ] The roadmap standards hold a coordinator shell section that names bash and tells the coordinator to write scripts with the Write tool.
- [ ] The section lists the zsh and JavaScript `replace` snags from the backlog entry.
- [ ] A script drains the queue items of a merged step, a script covers the overlap check, and a script applies a bulk edit.
- [ ] A test shows `merge-guard` and `block-forced-add` still block variable, compound, and quoted commands.
