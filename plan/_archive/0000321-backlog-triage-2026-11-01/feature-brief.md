---
title: "Feature Brief - Backlog triage"
summary: "The backlog gets a priority and theme per entry, a generated index, a staleness review, and a CI check."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Backlog triage

**Feature ID:** 0000321-backlog-triage

## Business Goal

The backlog holds 59 entries and nothing lists them in one place. Entries have no priority or theme, so P0 pickup offers them one at a time in id order. Nothing flags an entry that has sat open for days or that a later change made obsolete. This feature lets a developer see the backlog at a glance and start pickup with what matters most.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Priority and theme fields | As a maintainer, I give each entry a priority and a theme, so that I can sort the backlog. | must-have | 1 |
| Generated index with a CI check | As a developer, I read `plan/backlog/index.md`, so that I see every open entry with its priority and theme at a glance. | must-have | 1 |
| Ordered pickup | As a developer, I see entries at P0 in priority and theme order, so that pickup starts with what matters most. | must-have | 1 |
| Staleness review | As a maintainer, I get a list of entries older than the review age, so that I can drop or confirm each one. | must-have | 1 |
| Default migration | As a maintainer, I get a default priority and theme on existing entries, so that the index is complete on day one. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Template, script, skills, migration, and CI workflow |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/backlog/` entries and `plan/backlog/index.md` | ravintio-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| CI | `backlog-index.mjs` | command line | Exit 1 when the committed index differs from a fresh run |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js, built-in modules only |
| Testing | Bash suites |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `priority` and `theme` in the backlog template frontmatter, and in the filing skill.
- A script that generates `plan/backlog/index.md`, checks it, and lists stale entries.
- A CI step that fails on a stale index, in the tracked workflow and the pack copy.
- Ordered pickup and the staleness review in Discovery Start Actions step 10.
- A migration that sets a default priority and theme on existing entries, applied in this repo.
- Tests and docs.

### Out of Scope
- Setting a real priority or theme on the 59 existing entries.
- Deleting or closing any stale entry.
- Any blocking hook.

### Deferred
- none

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | Same entries give a byte-identical index | Test runs the script twice |
| Security | The script prints no entry body text and treats entry text as data | Test with a malformed entry |

## Constraints and Assumptions

### Constraints
- Code and docs land together. No new library.
- A malformed entry is flagged, never parsed as instructions.

### Assumptions
- Entries keep the `**Date filed:**` field. An entry without one is flagged as undated.

## Scenario Paths

**Happy path:** Each entry has a priority and a theme. The script writes the index grouped by theme and ordered by priority, and CI passes.

**First-run path:** Existing entries have no fields. The migration sets `medium` and `unsorted`, and the script reads a missing field as those defaults.

**Error path:** An entry has an unreadable frontmatter or an unknown priority. The script lists it as malformed, exits 1, and writes no index.

**Cross-session continuity:** The index is a tracked file. CI compares it with a fresh run, so a stale index never lands.
