---
title: "Feature Brief - Scan new pack files for the wording allowlist"
summary: "The test impact scan gets a Pack content cause that lists the repo-wide wording tests for a run that adds a content file under the pack."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Scan new pack files for the wording allowlist

**Feature ID:** 0000569-scan-new-pack-files-for-wording-allowlist

Folded in from backlog entry 0000415.

## Business Goal

A new content file under `ravintio-zero/` can hold a word that `test-0000042-req-010-pack-wording-allowlist.sh` bans. The scan has no cause for it, so the full suite found the breach late. The scan must list the wording tests at plan time.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Pack content cause | As a plan author, I list the repo-wide wording tests when a run adds pack content, so that no banned word reaches the full suite. | must-have | 1 |

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
- One new `Pack content` cause in `skills/ravintio-plan/references/test-impact-causes.md`, in both pack trees.
- One new test suite that checks the cause.
- A scan cap of 21 lines in the three suites that cap it at 20.

### Out of Scope
- A script that scans new files for banned words.
- Causes that step 26 adds.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Trees | `src/ravintio-zero/` and `ravintio-zero/` hold the same file | `cmp` |
| Scan size | 21 lines or fewer | line count |

## Constraints and Assumptions

### Constraints
- Edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.
- The scan holds 20 lines and the cause adds one, so the cap rises to 21.

### Assumptions
- The entry names `SKILL.md`. The causes live in the reference file, so the cause goes there.

## Scenario Paths

**Happy path:** A plan author plans a run that adds a content file under `ravintio-zero/`. The author reads the scan and lists `test-0000042-req-010` and the other wording tests in the execution plan.

> The scan names the cause.

**First-run path:** No state exists. The file is static text.

> Not applicable.

**Error / sad path:** The cause loses its wording.

> A test fails, because it pins the wording.

**Cross-session continuity:** No state is at risk. Every output is text in git.

> Not applicable.

## Acceptance Criteria

- [ ] The reference file has a `Pack content` cause that names `test-0000042-req-010` and says to list the wording tests in the execution plan.
- [ ] A test checks that the scan names the cause, in both trees.
- [ ] The scan stays at 21 lines or fewer.
