---
title: "ADR 005: Tag after the squash merge in a roadmap step"
summary: "In a roadmap step, P4 squash-merges the PR into the roadmap branch, fetches, tags the squash commit, and pushes the tag. Outside a roadmap, tag-before-PR stays. The roadmap PR asks for a merge commit."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000043-autonomous-roadmaps"
---
# ADR-0153 - Tag after the squash merge in a roadmap step

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Component:** planifest-zero
**Date:** 2026-10-23

## Context

The ship skill tags the feature branch tip before it raises the PR. That works when the human merges with a merge commit, because the tagged commit lands on `main`.

A roadmap step differs. The agent squash-merges the step PR into the roadmap branch, and a squash creates a new commit. A tag on the feature branch tip would point at a commit the roadmap branch never holds.

The human wants one commit per feature on the roadmap branch. The human also expects to merge the roadmap PR into `main` with a merge commit. Each step then keeps its own commit on `main`, and each step tag stays reachable from `main`.

## Decision

In a roadmap step, P4 follows this order:

1. Raise the PR with `--base roadmap/{id}-{slug}`.
2. Wait for green CI.
3. Run `gh pr merge --squash`. The merge-guard hook allows this only for a `roadmap/*` base.
4. Fetch the roadmap branch.
5. Tag the squash commit and push the tag.

**Version source.** The step's `Bump` column in `roadmap.md` sets the version. P0 applies the bump to the roadmap branch's version, read from `product.yml`, or from `docs/about.md` when `product.yml` is absent. The existing downgrade block still applies. The tag takes that version.

**Outside a roadmap.** A run with no active roadmap keeps tag-before-PR. The human still merges, and the ship skill stays the same for that case.

**Roadmap PR.** R-E Delivery raises the roadmap PR to `main`. Its body asks the human for a merge commit, not a squash, so the step tags stay reachable from `main`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep tag-before-PR in roadmap steps | One ship order for every run. No new rule | The tag points at the feature tip, which the squash orphans | The tag would not exist on the roadmap branch or on `main` |
| Merge-commit each step into the roadmap branch | The feature tip stays reachable, so tag-before-PR works | The roadmap branch holds every WIP commit from every step | The human wants one commit per feature on the roadmap branch |
| Tag once at the end of the roadmap | One tag, one version | Steps have no tags of their own. The Bump column has no use | The human wants a version per step, and each step builds on the last |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | The ship skill gains a roadmap-step path with a post-merge tag. `pipeline-reference.md` records both tag orders. The R-E Delivery text gains the merge-commit request |

## Consequences

**Positive:**
- Each step tag points at a commit that exists on the roadmap branch.
- One squash commit per feature keeps the roadmap branch history short.
- A merge commit on the roadmap PR keeps every step tag reachable from `main`.

**Negative:**
- If the human squashes the roadmap PR, the step tags point at commits `main` does not hold.
- The ship skill now has two tag orders. A reader must check whether a roadmap is active.
- P4 must wait for CI before it tags, so a slow CI run delays each step.

**Risks:**
- The human might squash the roadmap PR by habit (R-004). The PR body asks for a merge commit, but nothing enforces it.
- The test repo might block squash merges or merge commits (R-008). The acceptance run checks the repo settings first.

## Related ADRs

- ADR-0150 - depends-on (the roadmap file stores the Bump and Version columns)
- ADR-0151 - depends-on (the agent squash merge into roadmap branches is what the tag follows)
- ADR-0152 - related-to (the driver runs the step that tags)

## Supersedes

- None

## Superseded By

- None
