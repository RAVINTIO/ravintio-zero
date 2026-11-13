---
title: "ADR 303: Git isolation in the test runners"
summary: "The runners give each suite a temporary global git config that refuses to guess an identity, so a missing identity fails locally."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000462-tests-without-git-identity"
---
# ADR-0303 - Git isolation in the test runners

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000462-tests-without-git-identity
**Component:** ravintio-zero
**File:** `docs/adr/0303-git-isolation-in-test-runners.md`
**Date:** 2026-11-10

## Context

PR #136 passed locally and failed in CI. A suite committed with no identity and relied on the developer's global git config. A CI runner has none.

## Decision

The runners point `GIT_CONFIG_GLOBAL` at a temporary file that holds `user.useConfigOnly = true`. They set `GIT_CONFIG_NOSYSTEM=1` and clear the author, committer, and `EMAIL` variables. Git then refuses a commit that names no identity. `helpers/git-isolation.sh` holds the Bash logic. `run-tests.ps1` sets the same variables.

Oldest shell: bash 3.2

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| `GIT_CONFIG_GLOBAL=/dev/null` alone | One variable | Git then guesses an identity from the user and host name, so the commit can still pass | It does not reproduce the failure |
| Set `HOME` to an empty folder | Needs no new git version | It breaks tools that read `HOME` | It changes more than git |
| A CI-only check | No local change | CI finds the failure first | It is the current gap |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Two runners, one helper, and suites that need an explicit identity |

## Consequences

**Positive:**
- A missing identity fails on a developer machine.
- Each suite gives the same result on any machine.

**Negative:**
- A suite that needs a global git setting must set it in its own call.

**Risks:**
- The runners drift apart. A test reads both.

## Related ADRs

- ADR-0284 - extends. The runners already clear RAVINTIO variables for each suite.

## Supersedes

- None

## Superseded By

- None
