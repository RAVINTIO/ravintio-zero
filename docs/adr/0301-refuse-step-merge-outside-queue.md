---
title: "ADR 301: merge-guard refuses a merge from a step session"
summary: "merge-guard blocks a merge command when RAVINTIO_INITIATIVE_QUEUE is 1, so only the merge queue merges a step PR."
status: "accepted"
component: "ravintio-zero"
feature: "0000458-refuse-step-merge-outside-queue"
version: "0.1.0"
---
# ADR-0301 - merge-guard refuses a merge from a step session

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000458-refuse-step-merge-outside-queue
**Component:** ravintio-zero
**File:** `docs/adr/0301-refuse-step-merge-outside-queue.md`
**Date:** 2026-11-10

## Context

Step 12 squash-merged its own PR #133. The PR got no version, no tag, and a `pending` chart row. ADR-0151 lets the agent squash its own PR into `initiative/*`, and `merge-guard` checks only the PR base. The standard says the queue merges a step PR.

## Decision

`merge-guard.mjs` reads `RAVINTIO_INITIATIVE_QUEUE`. When it equals `1` and a command trips the raw-text wire, the guard exits 2 before it parses the command. The queue runs as a driver process and trips no hook, so it still merges. A step with no concurrent driver leaves the variable unset and keeps today's path.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Check `RAVINTIO_INITIATIVE_STEP` | Covers serial steps | The serial step runs the merge itself through the queue and the plain line | The backlog entry names the queue variable, and the serial path stays valid |
| Keep the guard and rely on the text | No code change | Step 12 shows that text alone fails | The guard is the enforcement point |
| Block only after the base check | Reuses the parser | A `gh` call and parse run for a command that always blocks | It adds work and a failure mode |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One env check in `merge-guard.mjs`, carve-out text, and tests |

## Consequences

**Positive:**
- Every step PR gets a version, a tag, and a `merged` row from the queue.

**Negative:**
- A step session under the driver cannot merge even in an emergency. The coordinator merges from a session with no variable.

**Risks:**
- The hook environment lacks the variable. The guard then keeps today's rules.

## Related ADRs

- ADR-0151 - narrows. The squash carve-out no longer covers a step session under the driver.
- ADR-0238 - keeps. Coordinator PRs ride the guard without the variable.

## Supersedes

- None

## Superseded By

- None
