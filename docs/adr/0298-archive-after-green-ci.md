---
title: "ADR 0298: An initiative step archives after green CI"
summary: "An initiative step raises its PR and waits for green CI before it archives. The archive is the last push, and the step writes ready only after the checks on that head pass."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0298 - An initiative step archives after green CI

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000452-ci-wait-before-archive
**Component:** ravintio-zero
**File:** `docs/adr/0298-archive-after-green-ci.md`
**Date:** 2026-11-10T13:32:26Z

## Context

Ship archives `plan/current/` before it raises the PR. After the archive, `gate-write` rejects code edits because `plan/current/design.md` is gone. The chart field `**Step CI fixes:** allowed` then never applies. Step 6 of initiative 0000360 blocked three times on PR #136. It also wrote `ready` without watching CI.

## Decision

An initiative step raises the PR first and waits for CI while `plan/current/` is open. A failing check gets an in-scope fix when the chart allows it. After green CI the step archives the run, writes the build report, and clears the sentinels. It pushes once, waits for the checks on the new head, and writes `ready` only when every check passed. A check that fails on the archive head stops the step with `Blocked:`. The chart ruled out a reopen route, so `gate-write` stays as it is. A normal run outside an initiative keeps its order.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A reopen route that restores the archive | Keeps the old order | Needs a `gate-write` rule that accepts a restored run | The chart rules it out |
| Archive before the PR and watch CI after | No change | The step cannot fix a failing check | This is the failure |
| Change the order for every run | One order | A human reviews a normal PR and gains nothing | Larger change with no need |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Edits the ship skill and the roadmap standards. Adds two tests. |

## Consequences

**Positive:**
- A step fixes its own failing CI with no human route.
- The merge queue receives `ready` only for a checked head.

**Negative:**
- The archive push runs CI a second time.

**Risks:**
- A failure on the archive head stops the step, because the step can no longer edit code.

## Related ADRs

- ADR-0297 - related-to

## Supersedes

- None

## Superseded By

- None
