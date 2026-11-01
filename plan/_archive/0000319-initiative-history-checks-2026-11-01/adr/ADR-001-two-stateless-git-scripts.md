---
title: "ADR 001: Check history with two stateless git scripts"
summary: "Two Node scripts read git and CI runs them."
status: "active"
version: "0.45.0"
---
# ADR-001 - Check history with two stateless git scripts

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000319-initiative-history-checks
**Component:** ravintio-zero
**Date:** 2026-11-01

## Context

PR #72 and PR #74 carried 23 untitled commits each to `main`, and PR #72 landed as a squash. GitHub offers no title rule for first-parent commits. The chart decided that CI finds an initiative PR from the merge commit message and adds no token scope.

## Decision

Two Node scripts with built-in modules only read git. `check-initiative-history.mjs` checks titles with no exception list. `check-main-merge.mjs` checks the parent count of the newest `main` commit when its message names an initiative PR. CI runs both. The workflow gets an `initiative/**` push trigger, and `release-tag` gets a ref guard. The human applies a ruleset that allows only the merge commit method on `main`, and a doc records it.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Call the GitHub API from CI | Exact PR data | Needs a token scope | The chart forbids a new scope |
| An exception list in the script | Passes old commits | Hides failures | The chart forbids it |
| A hook instead of CI | Runs earlier | Hooks run on one machine | CI covers every contributor |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Two scripts, two workflow copies, standards, initiative skill, docs, tests |

## Consequences

**Positive:**
- A bad history fails the PR before it reaches `main`.
- A squash of an initiative PR is flagged at once.

**Negative:**
- The main check reads the message, so a renamed squash title slips past it.
- Every PR into `main` from an initiative branch now needs a full history of titled commits.

**Risks:**
- The push trigger could start `release-tag` on the wrong ref. The job guard and a test cover it.

## Related ADRs

- ADR-001 of 0000318 (titled coordinator PRs)

## Supersedes

- None

## Superseded By

- None
