---
title: "ADR 002: Find step commits by version tag and move tags by delete"
summary: "The script finds each step commit through its v{Version} tag and moves tags by delete and recreate."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000353-reshape-at-delivery"
---
# ADR-0247 - Find step commits by version tag and move tags by delete

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Component:** ravintio-zero
**Date:** 2026-11-06

## Context

A step squash on the old branch carries the title form of the day it shipped, so the subject cannot identify it. The chart `Version` column names the tag that ship set at the step. The human set on 2026-11-01 that a tag never moves by force push.

## Decision

The script reads `v{Version}` from the chart for each step and peels the tag to its commit. The commit must lie on the first-parent line from the merge base to the branch head. With `--tags` it deletes the local tag and creates a tag with the same name and message at the new step commit. With `--push` it pushes the new branch, deletes each old tag on `origin` with the refspec `:refs/tags/{tag}`, then pushes each new tag by name.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Match steps by subject | No tag needed | Old titles differ across steps | Brittle |
| Move tags with a force push | One command | Rewrites a published tag in place | The human ruled it out |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | A tag-based lookup and a tag move. |

## Consequences

**Positive:**
- Step lookup does not depend on a title form.
- No force push of a branch or a tag.

**Negative:**
- A step with no tag blocks the reshape.

**Risks:**
- See R-001 to R-005 in the risk register.

## Related ADRs

- ADR-0246 - related

## Supersedes

- None.

## Superseded By

- None.
