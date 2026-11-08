---
title: "ADR 003: Each phase skill lists its own fast batch"
summary: "The dispatch standard defines fast batch rules, and each phase skill lists the units it dispatches in one message."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000172-subagent-acceleration"
---
# ADR-0187 - Each phase skill lists its own fast batch

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000172-subagent-acceleration
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

The dispatch standard already says the default posture is parallel. Each phase still decides its own batches, so runs split work unevenly. A phase agent loads its own skill in full, but reads the dispatch standard only before it spawns an agent.

## Decision

The dispatch standard gains a `## Fast batches` section with the rules every batch follows. Each phase skill gains a `### Fast batch` subsection that lists its units in order. Phases still run in order, and gates and exception stops stay unchanged. Per-requirement streams across phases stay out of scope.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| One list of all units in the dispatch standard | One place to read | The phase agent sees it only when it already plans to spawn | The list must sit where the phase agent reads it |
| Overlapping phases with per-requirement streams | Larger gain | Gates would need a new join rule | The wanted outcome keeps phases in order |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Dispatch standard and four phase skills |

## Consequences

**Positive:**
- Each phase agent sees its fast batch in the skill it already loads.

**Negative:**
- Four lists to keep in step with each phase's steps.

**Risks:**
- Two units in one batch write the same file. The rules require disjoint files.

## Related ADRs

- ADR-0186

## Supersedes

- None

## Superseded By

- None
