---
title: "Feature Brief - Step titles and history shape"
summary: "Titles every step commit with its feature title and checks the shape of an initiative branch."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Step titles and history shape

**Feature ID:** 0000351-step-titles-and-history-shape

## Business Goal

A reader can't match an initiative step commit to its feature, because the squash title holds free text. The history check also ignores the shape of the branch, so coordinator commits between steps pass. This feature titles each step commit with its feature title and makes the check enforce one commit per step, then at most one chore commit.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Step title form | As a maintainer, I read `{feature-id}: {Feature title} (#{n})` on each step commit, so that I match a commit to its feature at a glance. | must-have | 1 |
| Title column | As a coordinator, I chart a `Title` column in the steps table, so that P0, ship, and the check read one title. | must-have | 1 |
| Shape check | As a reviewer, I run `check-initiative-history.mjs` and it fails any commit that is not a charted step in order or the one chore commit, so that stray coordinator commits fail CI. | must-have | 1 |
| One-commit PR subject | As a coordinator, I write the commit subject of a one-commit PR in the titled form, so that the squash keeps the title. | should-have | 1 |
| Chart-format migration | As a step author, I update the active `initiative.md` when my step changes a chart format, so that no later step stops on the old format. | should-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, templates, and scripts of the pipeline |

### Data Ownership

None. The feature changes documents and one script. It touches no data store.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `check-initiative-history.mjs` | `plan/current-initiative/initiative.md` | file read | The `## Steps` table with a `Title` column |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM scripts) and Markdown |
| Runtime | Node |
| Testing | Bash test scripts in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- Ship titles the step PR `{feature-id}: {Feature title}`, using the `Title` column.
- The `Title` column in `initiative.template.md`, and its use as the feature brief title in P0.
- `check-initiative-history.mjs` reads the `Title` column, matches each step title exactly, and checks the N + 1 shape.
- Title rules in `roadmap-standards.md` and `commit-standards.md`, including the one-commit coordinator PR subject (entry 0000339).
- The rule from entry 0000268 in the plan skill and the standards.

### Out of Scope
- Coordinator queueing, `--delete-branch`, and `reserve-id.mjs` (step 2).
- The reshape script (step 3).
- Rechecking delivered history on `main`.

### Deferred
- Rules 1, 2, 3, and 5 of entry 0000345 stay in the backlog for steps 2 and 3.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | The check gives the same result for the same git history | Fixture tests |

## Constraints and Assumptions

### Constraints
- The change widens no guard. The check tightens.
- Prose follows the writing standard.

### Assumptions
- The active chart already holds the `Title` column.

## Scenario Paths

**Happy path:** Chart fills `Title`. P0 uses it as the brief title. Ship titles the PR from it. The squash carries it. At delivery the check passes N titled steps and one chore commit.

> Drafted from the brief. Accepted by the initiative chart.

**First-run path:** An initiative with no `Title` column fails the check with a message that names the missing column.

> Drafted from the brief. Accepted by the initiative chart.

**Error / sad path:** A mistitled step or an extra commit between steps makes the check exit 1 and print the failing commit.

> Drafted from the brief. Accepted by the initiative chart.

**Cross-session continuity:** The check keeps no state. It reads git and the chart, so an interrupted run loses nothing.

> Drafted from the brief. Accepted by the initiative chart.

## Acceptance Criteria

- [ ] A fixture with N titled steps and one chore commit passes the check.
- [ ] A fixture with a mistitled step fails the check.
- [ ] A fixture with an extra commit between steps fails the check.
- [ ] `initiative.template.md` has a `Title` column in `## Steps`.
- [ ] The ship skill titles the step PR `{feature-id}: {Feature title}`.
- [ ] `roadmap-standards.md` and `commit-standards.md` state the title forms and the one-commit PR subject rule.
- [ ] The plan skill and the standards tell a step that changes a chart format to update the active `initiative.md`.
