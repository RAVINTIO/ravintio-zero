---
title: "ADR 005: Park keeps the work on the feature branch"
summary: "Park keeps the work on its feature branch, files a parked backlog entry through a chore PR to main, and returns the working tree to main. Resume and discard happen at a later P1."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000040-setup-json-checks-and-park"
---
# ADR-0141 - Park keeps the work on the feature branch

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Component:** planifest-zero
**Date:** 2026-10-21

## Context

A human sometimes needs to set a part-finished feature aside and start other work (backlog 0000101). Nothing shelves a feature today. The work must not be lost, and `main` must stay clean. Repo rules forbid committing to `main`, merging pull requests, and force-pushing.

## Decision

Park keeps the work on the feature branch:

1. Write `plan/current/park.md` from `park.template.md`. Commit it and push the feature branch.
2. Cut `chore/park-{feature-id}` from `main`. Add a backlog entry with status `parked` that names the branch. Push it and run `gh pr create`.
3. Check out `main`. The sentinels live on the feature branch only.
4. If a push or `gh` call fails, report the exact error and stop on the feature branch.

At P1 backlog pickup, a `parked` entry offers two choices. Resume checks out the branch, merges `origin/main`, and restores state from `park.md`. Discard deletes the branch locally and on `origin` after the human confirms.

Park never merges, never commits to `main`, and never force-pushes. The human merges the chore PR.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Snapshot `plan/current` to `plan/parked/` on `main` and delete the branch | Everything sits on `main` | Loses the code, and needs a commit to `main` | Loses work and breaks the `main` rule |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | The orchestrator skill gains the park section and parked-entry handling. A new `park.template.md` and contract tests land with it |

## Consequences

**Positive:**
- Code and plan state stay together on one branch, so no work disappears.
- `main` needs no cleanup, and every change lands through a PR.
- Discard needs a human confirmation, so no branch goes silently.

**Negative:**
- A parked feature leaves a branch and an open PR until the human merges or discards.
- Resume must merge `origin/main`, so conflicts can appear.
- Only one parked feature fits in a working tree at a time.

**Risks:**
- A session ends mid-step and leaves a half-done state. Resume detection that finds `park.md` with no chore PR finishes step 2.
- `gh` is missing or not signed in. Park stops at step 2 with the branch pushed, and the human files the PR.

## Related ADRs

- ADR-0137 - related-to (park uses git and `gh` only)

## Supersedes

- None

## Superseded By

- None
