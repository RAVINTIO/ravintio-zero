---
title: "ADR 001: The driver keeps running and ready in the control area"
summary: "The driver keeps running and ready in the control area"
status: "accepted"
version: "0.1.0"
---
# ADR-001 - The driver keeps running and ready in the control area

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

Backlog entry 0000375 says the chart tracks `running`, `ready`, and `merged`. Nothing commits directly on `initiative/*`, so a driver edit of the chart would need a coordinator PR for each state change. The main working tree also holds the initiative branch, where the driver never edits files.

## Decision

The committed chart holds `pending` and `merged`. The driver derives `running` and `ready` from `plan/.initiative-control/step-{n}/` and prints them. The parser accepts all four values. The merge queue writes `merged`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Commit each state to the chart | One record | A PR per state change, and a dirty main tree | The history rule and the no-edit rule forbid it |
| Keep all states in the driver memory | No files | A restart loses them | Cross-session continuity needs them on disk |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` and `initiative-watch.mjs` read the control area. |

## Consequences

**Positive:**
- The chart stays a committed record of merges only.

**Negative:**
- A reader of the chart alone cannot see a running step.

**Risks:**
- A stale control folder misreports a step. The driver clears a step's folder when the step merges.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
