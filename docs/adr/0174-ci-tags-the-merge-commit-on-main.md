---
title: "ADR 002: CI tags the merge commit on main"
summary: "Ship stops tagging before the merge. A CI job on a push to main tags the pushed commit with the product version."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000169-release-hygiene"
---
# ADR-0174 - CI tags the merge commit on main

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000169-release-hygiene
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

Ship Step 7 tags the feature branch tip. The human squash-merges each PR, so the tagged commit never reaches `main`. Backlog 0000167 offers two fixes: a post-merge step that the human triggers, or a CI job on a push to `main`. Roadmap R-D Advance already tags the squash commit after its own merge.

## Decision

A `release-tag` job runs on a push to `main` or `master`. It runs `ravintio-zero/scripts/release-tag.mjs`.

- The script reads `version` from `product.yml`, or from `docs/about.md` when `product.yml` is absent.
- If `v{version}` exists, the script exits 0 and changes nothing.
- Otherwise it creates an annotated tag on `HEAD` with the `feature` id as its message, and pushes it.
- Only this job holds `contents: write`. The pull request jobs run only on `pull_request`.
- Ship Step 7 creates no tag. A local-git-only run prints the tag command for the human.
- R-D Advance keeps its tag step. A roadmap PR merges into `main` with a merge commit, so its tags are already reachable, and the job skips.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Post-merge step after the human reports the merge | No CI write token | Needs a second agent session and a human prompt | The tag waits on a manual step |
| Keep the tag on the feature branch | No change | The tag names a commit off `main` | The problem the backlog entry records |
| Tag on `pull_request` closed and merged | Knows the PR | Runs PR-event code with a write token | A push event runs only code already on `main` |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New script, CI job in both workflow files, ship skill and docs edits |

## Consequences

**Positive:**
- Every release tag names a commit on `main`, with no human step.
- Chore PRs that keep the version leave the tag where it is.

**Negative:**
- One CI job holds a write token.
- Consumers with an existing workflow file get no job until they copy it in.

**Risks:**
- A PR that forgets the version bump leaves the merge untagged. The tag then lands with the next bump.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
