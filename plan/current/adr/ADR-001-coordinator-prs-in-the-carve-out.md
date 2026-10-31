---
title: "ADR 001: Coordinator PRs ride the existing merge-guard"
summary: "Coordinator work reaches the initiative branch as titled PRs that the agent squashes under the current hook."
status: "active"
version: "0.44.0"
---
# ADR-001 - Coordinator PRs ride the existing merge-guard

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000318-titled-coordinator-prs
**Component:** ravintio-zero
**Date:** 2026-10-31

## Context

Coordinator work commits directly on `initiative/*`, so the history holds untitled commits that skip CI. The written carve-out lets the agent squash only its own feature PR. `merge-guard` checks the PR base, so it already allows a squash of any PR into `initiative/*`.

## Decision

Coordinator work reaches the branch as a titled PR. The agent squashes it after a passing local suite and green CI. The written carve-out names coordinator PRs and keeps its other conditions. `merge-guard` does not change. A test pins its behaviour.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| The human lands coordinator PRs | No wording change | Stops the run for each PR | Slows the run |
| Coordinator work rides in the next step PR | No new PR | Mixes unrelated changes into one squash | Breaks one change per squash |
| Widen `merge-guard` | Hook states the rule | Widens a fail-closed guard | The chart forbids it |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Standards, initiative skill, ship skill, tests |

## Consequences

**Positive:**
- The first-parent history is one titled squash per change.
- Coordinator changes get CI.

**Negative:**
- Each coordinator PR costs a suite run and a CI wait.

**Risks:**
- The written rule is broader than the hook. The standards state the bar, and the human approved this on 2026-10-31.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
