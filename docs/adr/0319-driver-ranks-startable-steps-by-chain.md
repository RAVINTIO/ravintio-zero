---
title: "ADR 0319: Driver ranks startable steps by chain length"
summary: "readySteps lists the startable steps with the longest chain behind them first, and chart order breaks ties."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0319 - Driver ranks startable steps by chain length

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000491-driver-favours-critical-path
**Component:** ravintio-zero
**File:** `docs/adr/0319-driver-ranks-startable-steps-by-chain.md`
**Date:** 2026-11-11

## Context

The driver fills a free slot with the first startable step in chart order. On 2026-11-10 the driver lane, steps 24 to 29 then 41, waited while steps in shorter lanes ran. The initiative took hours longer than its longest chain required.

## Decision

`readySteps` in `initiative-chart.mjs` orders the startable steps by chain length, longest first. Chart order breaks ties. The chain length of a step is 1 plus the longest chain among its unmerged dependants. A dependant lists the step in `After`, or is the next unmerged step in the same lane. A cycle ends the count at the step that repeats. The driver needs no change, because it takes the first free steps of the list. The ranking counts steps and not time.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Chart order, as before | No change | Long chains wait behind short ones | It caused the delay |
| Weight each step by its past duration | Closer to the true critical path | Needs timing data that the chart does not hold | Out of scope. A later entry can add it |
| Rank in the driver | The driver owns the slots | It splits the start logic across two files | `readySteps` already decides what may start |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New order in `readySteps`, and new text in `roadmap-standards.md` |

## Consequences

**Positive:**
- The longest chain starts first, so the initiative ends nearer its minimum time.
- The order is a pure function of the chart, so a restarted driver gets the same order.

**Negative:**
- A short step in a long chain can start before a long step in a short chain.
- Lane order now counts as a dependency in the rank.

**Risks:**
- A cycle in the `After` lists. The count stops at the repeated step.

## Related ADRs

- 0000379 ADR-002 - extends: the scheduler starts steps by lane and `After` list.

## Supersedes

- None.

## Superseded By

- None.
