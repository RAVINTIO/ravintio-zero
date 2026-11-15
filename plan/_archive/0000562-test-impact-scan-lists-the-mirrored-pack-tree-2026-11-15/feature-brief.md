---
title: "Feature Brief - Test impact scan lists the mirrored pack tree"
summary: "The plan skill's Test impact scan gains a Pack file edit cause, and its causes move to a reference file."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Test impact scan lists the mirrored pack tree

**Feature ID:** 0000562-test-impact-scan-lists-the-mirrored-pack-tree

Folded in from backlog entry 0000540.

## Business Goal

Step 61 of an earlier initiative edited pack files in `ravintio-zero/` only. The first full suite run failed `test-0000493-req-004-handoff-text.sh`, because `src/ravintio-zero/` must match. The plan scan has no cause for this, so the gap surfaced late. The scan must name it at plan time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Move the scan causes | As a plan author, I read the Test impact scan causes from a reference file, so that the plan skill stays small. | must-have | 1 |
| Pack file edit cause | As a plan author, I see a `Pack file edit` cause that lists `test-0000493-req-004-handoff-text.sh`, so that I plan the mirrored edit in the same unit. | must-have | 1 |
| Component paths | As a P0 author, I list `src/ravintio-zero/` in `## Component Paths` when the run edits a pack file, so that gate-write allows the mirrored edit. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Plan skill text and its tests |

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
- A reference file `skills/ravintio-plan/references/test-impact-causes.md` that holds every scan cause, and a Pack Index row for it in the plan skill.
- A `Pack file edit` cause.
- A P0 rule in the orchestrator that lists `src/ravintio-zero/` in `## Component Paths` when the run edits a pack file.
- Updated pins in the three suites that read the scan, and one new suite.

### Out of Scope
- Causes that steps 19 to 27 add.
- Changes to hooks or scripts.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill size | `ravintio-plan/SKILL.md` ends smaller than 13947 bytes | `wc -c` |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.

### Assumptions
- `sync-installed.mjs` copies a new reference file to the installed tree.

## Scenario Paths

**Happy path:** A plan author reads the scan, finds the `Pack file edit` cause, and lists the handoff suite.

> The scan names the cause and the suite. P0 lists both trees.

**First-run path:** No state exists. The files are static text.

> Not applicable.

**Error / sad path:** The plan skill omits the reference row.

> A test fails, because it checks the Pack Index row.

**Cross-session continuity:** No state is at risk. Every output is text in git.

> Not applicable.

## Acceptance Criteria

- [ ] The plan skill's `## Test impact scan` section points to `references/test-impact-causes.md`, and every earlier cause sits in that file.
- [ ] The file holds a `Pack file edit` cause that names `test-0000493-req-004-handoff-text.sh`.
- [ ] The orchestrator tells P0 to list `src/ravintio-zero/` in `## Component Paths` for a pack file edit.
- [ ] A test checks all three.
