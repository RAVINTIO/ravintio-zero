---
title: "Feature Brief - Tests catch runner-only failures"
summary: "The local runners hide the developer's git identity, and a fixture covers a boot file that starts with a BOM."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Tests catch runner-only failures

**Feature ID:** 0000462-tests-without-git-identity

Source: backlog entry 0000414, a postmortem action from PR #136 (`plan/postmortems/2026-11-08-archived-step-cannot-fix-ci.md`).

## Business Goal

PR #136 passed 317 feature suites locally and failed two CI jobs. One suite relied on the developer's global git identity, and `doctor` did not strip a BOM. The local suite now fails on both defects, so CI finds nothing that a local run could have found.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Git identity isolation | As a maintainer of the pack, I see a suite fail locally when it commits with no identity, so that CI does not find it first. | must-have | 1 |
| BOM fixture | As a maintainer of the pack, I see a suite fail locally when a script cannot read a boot file that starts with a BOM, so that Windows PowerShell 5.1 files do not fail only in CI. | must-have | 1 |

## Wanted outcome

- With the PR #136 fixes reverted, the local suite fails on both defects.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the runners, the helpers, and their tests |

### Data Ownership

No data store.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash and PowerShell runners, Node scripts, already in the pack |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- `run-tests.sh` and `run-tests.ps1` run each suite with no global or system git config, and with an identity requirement that fails when the repository sets none.
- Fixes to any suite that this isolation exposes.
- A BOM fixture and a suite that runs each first-line reader against it. A reader that fails gets a fix.
- Docs, an ADR, and a changelog entry.
- The sync of `ravintio-zero/` with `sync-installed.mjs`.

### Out of Scope
- Other differences between local and CI runs, such as the OS and the shell.
- A CI job change.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Local fidelity | The two PR #136 defects fail locally | A suite reverts each fix in a scratch copy and expects a failure |

## Constraints and Assumptions

### Constraints
- No new library or service.

### Assumptions
- Git honours `GIT_CONFIG_GLOBAL`, `GIT_CONFIG_NOSYSTEM`, and `user.useConfigOnly`. Impact if wrong: the isolation does not reproduce the CI failure.

## Scenario Paths

**Happy path:** the runner hides the developer's config, every suite sets its own identity, and the run passes.

**First-run path:** a new suite commits with no identity. The local run fails and names the suite.

**Error / sad path:** a boot file starts with a BOM. A reader that does not strip it fails the fixture suite.

**Cross-session continuity:** not applicable.

## Acceptance Criteria

- [ ] The runners hide the global and system git config from each suite, and git refuses to guess an identity.
- [ ] A suite that commits with no identity fails locally.
- [ ] A BOM fixture runs against each first-line reader and each reader passes.
- [ ] With the PR #136 fixes reverted, the local suite fails on both defects.
