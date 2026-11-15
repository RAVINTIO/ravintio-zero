---
title: "Feature Brief - Test impact scan names hook pins"
summary: "The plan skill's Test impact scan gains a Hook change cause that lists the greps for suites pinning hook behaviour."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Test impact scan names hook pins

**Feature ID:** 0000564-test-impact-hook-pins

Folded in from backlog entry 0000523.

## Business Goal

Step 51 of an earlier initiative added a `PostToolUse` hook and cut the reply-time margin from 5 to 2 minutes. Six suites pinned the old behaviour. The plan named three and the full suite found the rest in P2. The scan must name the greps at plan time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Hook change cause | As a plan author, I see a `Hook change` cause, so that I grep the tests for the hook name, count words, fixture, and margin text. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Plan skill reference text and its tests |

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
- A `Hook change` cause in `skills/ravintio-plan/references/test-impact-causes.md`, in both pack trees.
- One new test suite that checks the cause.

### Out of Scope
- Causes that steps 21 to 27 add.
- Changes to hooks or scripts.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Trees | `src/ravintio-zero/` and `ravintio-zero/` hold the same file | `cmp` |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.

### Assumptions
- The plan skill needs no edit, because the reference file already has a Pack Index row.

## Scenario Paths

**Happy path:** A plan author adds a hook and reads the scan. The author then greps the tests for the four targets.

> The scan names the cause and the four greps.

**First-run path:** No state exists. The file is static text.

> Not applicable.

**Error / sad path:** The cause is missing from the reference file.

> A test fails, because it checks the cause.

**Cross-session continuity:** No state is at risk. Every output is text in git.

> Not applicable.

## Acceptance Criteria

- [ ] `references/test-impact-causes.md` holds a `Hook change` cause that fires when a run adds, removes, or changes a hook.
- [ ] The cause names four grep targets: the hook name, hook count words, the `expected-after.txt` fixture with `pack-facts`, and the margin or status text.
- [ ] A test checks the cause in both trees.
