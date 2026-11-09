---
title: "ADR 002: The run speed lives in its own sentinel file"
summary: "plan/.run-speed holds fast or standard, and plan/.run-mode keeps its two values."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000172-subagent-acceleration"
---
# ADR-0186 - The run speed lives in its own sentinel file

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000172-subagent-acceleration
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

Backlog entry 0000110 suggests `fast` in `plan/.run-mode` or a loop toggle. `plan/.run-mode` accepts only `gated` and `autonomous`, and five pack files plus the 0000042 suites rely on that rule. Speed and stopping are separate choices. A gated run can be fast, and an autonomous run can be standard. Loop toggles live in `ravintio-overrides/loop-toggles.yml`, which the pipeline never writes.

## Decision

The orchestrator writes the speed to `plan/.run-speed`, one line, `fast` or `standard`. A missing or unknown value counts as `standard`. A roadmap step takes the speed from the roadmap's `**Speed:**` field. Ship Step 8 deletes the file with the other sentinels.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| `fast` as a third `plan/.run-mode` value | One file | Mixes speed with stopping and breaks the two-value rule | A fast gated run would need a fourth value |
| A loop toggle | Existing file | The pipeline never writes toggles, so the run cannot record a per-run answer | Speed is a per-run choice |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Orchestrator, ship skill, roadmap standards, and roadmap template text |

## Consequences

**Positive:**
- Runs and roadmaps that predate the file run at `standard` with no change.

**Negative:**
- One more sentinel file to clear at ship.

**Risks:**
- A stale `plan/.run-speed` reaches a roadmap branch. Ship Step 8 deletes it before the PR.

## Related ADRs

- ADR-0187

## Supersedes

- None

## Superseded By

- None
