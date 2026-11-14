---
title: "Feature Brief - Step base merge regenerates the backlog index"
summary: "I-D Advance tells a step to rebuild the backlog index after a manual base merge and names the CI check that fails otherwise."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Step base merge regenerates the backlog index

**Feature ID:** 0000547-step-merge-regenerates-index

## Business Goal

On 2026-11-11 step 29 merged the initiative branch by hand and left `plan/backlog/index.md` stale. CI failed twice on `backlog-index.mjs --check`, and one more commit fixed it. The step text must say to rebuild the index after a manual base merge.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Index rebuild line in I-D Advance | As a step session, I rebuild the backlog index after a manual base merge, so that CI does not fail on a stale index. | must-have | 1 |
| Standards test for the line | As the human, I want a test to check the line, so that a later edit cannot drop it. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, and tests that define the pipeline |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/backlog/index.md` | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown standards, Bash tests |
| Testing | `ravintio-zero/tests/` shell tests |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- One rule in `### I-D Advance` of `roadmap-standards.md`, in `src/ravintio-zero/` and mirrored to `ravintio-zero/`.
- A standards test that reads the rule.
- The living docs and an ADR.

### Out of Scope
- Any change to `merge-queue.mjs`, `shared-files.mjs`, or `backlog-index.mjs`.
- Any hook or CI workflow change.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Rule names the failing CI check | 1 check named | A test reads the rule text |

## Constraints and Assumptions

### Constraints
- No guard widens. The change adds standards text and a test only.

### Assumptions
- A step session reads I-D Advance before it merges the base branch by hand.

## Scenario Paths

**Happy path:** The PR conflicts. The step merges the initiative branch, runs `backlog-index.mjs`, commits the result, and pushes. CI passes.

**First-run path:** The PR does not conflict. The step runs no manual merge, so the rule does not apply.

**Error / sad path:** The step forgets the rebuild. The `Check the backlog index` step of `validate-branch` fails, and the step reads the rule to fix it.

**Cross-session continuity:** The rule lives in the standards, so a resumed step session reads the same text.

## Acceptance Criteria

- [ ] I-D Advance says to run `node ravintio-zero/scripts/backlog-index.mjs` after a manual base merge and to commit the result before the push.
- [ ] The rule names the CI check that fails if the index is stale.
- [ ] A standards test checks both parts of the rule.
