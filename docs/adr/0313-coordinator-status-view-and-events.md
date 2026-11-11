---
title: "ADR 313: Coordinator status view and event notices"
summary: "A read-only status script, chart-based watcher state, and new watcher and driver events give the coordinator one true view of the run."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000450-coordinator-status-view"
---
# ADR-0313 - Coordinator status view and event notices

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000450-coordinator-status-view
**Component:** ravintio-zero
**File:** `docs/adr/0313-coordinator-status-view-and-events.md`
**Date:** 2026-11-11

## Context

In initiative 0000360 the coordinator missed a ready line for 24 minutes and a driver exit for two hours. It also gave a wrong status twice. The watcher read stale control files and showed merged steps as ready. The driver held the queue failure reason until exit.

## Decision

Add `initiative-status.mjs`, a read-only script. It prints the driver state, step counts, ready PRs, running steps, and live stops. The chart `Status` column decides which steps have merged. A stop for a merged step does not show.

The watcher reads the same chart status. It prints an event for a new `ready` file, a queue stop line in a step log, and a driver exit. The driver prints the queue failure reason when it happens and appends it to the step log. The initiative skill defines a report that lists decisions apart from routine fixes.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Put the status view in the watcher only | One program | A coordinator cannot ask for the state on demand | The coordinator needs a view at each report |
| Have the driver write a state file | One source of truth | A new file format and a driver write path | The chart and control folders already hold the state |
| Clear stale stop lines in the driver | Fewer lines | Changes which stops the driver takes | Out of scope for this step |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New script, changed watcher and driver output, changed skill text |

## Consequences

**Positive:**
- The coordinator reports from one view that drops cleared stops.
- A ready file, a queue failure, and a driver exit each print an event.

**Negative:**
- The driver and watcher files change, so the restart stop fires after this step merges.

**Risks:**
- A test that matches driver output exactly may need an update.

## Related ADRs

- ADR-0309 - related-to

## Supersedes

- None.

## Superseded By

- None.
