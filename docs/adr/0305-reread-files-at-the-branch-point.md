---
title: "ADR 305: Reread files at the branch point"
summary: "The plan skill rereads each file a unit edits from the tip of the PR base branch and records the commit it read."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000470-plan-rereads-files-at-the-branch-point"
---
# ADR-0305 - Reread files at the branch point

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000470-plan-rereads-files-at-the-branch-point
**Component:** ravintio-zero
**File:** `docs/adr/0305-reread-files-at-the-branch-point.md`
**Date:** 2026-11-10

## Context

Parallel steps change shared scripts within minutes. In step 16, a queue test fake matched a script from before another step merged. The first run sat in the CI wait, and the postmortem set the preventive action to none.

## Decision

The plan skill gains a Branch-point reread section. The plan runs `git fetch origin` and reads each file a unit edits from `origin/{base}`. It records the last commit that changed the file in the `## Branch-point reads` table of the execution plan. It repeats the reread if the base moves before the plan gate.

Oldest shell: bash 3.2

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A script that checks the reads | Mechanical | New code to maintain, and the commit note still needs the plan | Out of scope for a skill text fix |
| A hook that blocks a stale plan | Fails closed | Adds a guard that a step cannot clear alone | Out of scope |
| Reread in P2 only | Closer to the edit | The plan and the tests have already rested on stale text | Too late |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One skill section and one template table |

## Consequences

**Positive:**
- A stale read shows up as a commit that differs from the base tip.
- The plan records what it read.

**Negative:**
- Each plan spends one fetch and one `git log` per file.

**Risks:**
- A step with no `origin` remote can't fetch. The section tells it to read the local base branch.

## Related ADRs

- ADR-0303 - related-to

## Supersedes

- none

## Superseded By

- none
