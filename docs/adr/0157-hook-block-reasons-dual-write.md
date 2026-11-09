---
title: "ADR 002: Hook block reasons go to stderr and stdout"
summary: "gate-write, em-dash-guard, and ratchet-check write each block reason to both stderr and stdout, as merge-guard does, so Claude sees the reason and tests can read either stream."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000151-hardening-efficiency-and-ci"
---
# ADR-0157 - Hook block reasons go to stderr and stdout

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Component:** planifest-zero
**Date:** 2026-10-24

## Context

The Claude Code hooks reference (hooks.md) states three facts. On exit 2, Claude sees stderr. Claude does not show plain stdout from a hook. Valid JSON on stdout supplies the reason in place of stderr.

`merge-guard` writes its reason to both streams. `gate-write`, `em-dash-guard`, and `ratchet-check` write to stdout only. The agent therefore sees a bare block with no reason, and the human cannot tell why a write failed. Existing tests read stdout, so a move to stderr alone would break them.

## Decision

Each of the three hooks writes the block reason to stderr and to stdout, then exits 2.

- The reason text is identical on both streams.
- The stdout write is plain text, not JSON. A JSON write would replace stderr and change what Claude sees.
- Each hook gets one test that reads stderr on a block. Existing stdout tests stay unchanged.
- The exit code, the block conditions, and the reason wording do not change.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Write to stderr only | Matches the documented channel. One write per block | Breaks every test that reads stdout | The tests would need rewrites, and stdout readers lose the reason |
| Write JSON to stdout | One structured write | Replaces stderr, so the plain-text channel no longer carries the reason. Differs from `merge-guard` | The pattern in `merge-guard` already works and needs no new format |
| Leave stdout only | No change | Claude never sees the reason | This is the defect the requirement fixes |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | Three hooks gain a stderr write. Three tests gain a stderr assertion |

## Consequences

**Positive:**
- The agent sees why a hook blocked a write and can correct it.
- All four blocking hooks behave the same way.
- Existing stdout tests keep passing.

**Negative:**
- A human running a hook in a terminal sees the reason twice.
- Each hook now has two writes to keep in step.

**Risks:**
- If Claude Code reads stdout in a future release, the agent may see the reason twice. The reasons are short, so the cost is low.
- The design assumes Claude reads only stderr on exit 2. If that is wrong, the change has no effect for agents and breaks nothing.

## Related ADRs

- ADR-0151 - related-to (introduced `merge-guard`, the model for this pattern)

## Supersedes

- None

## Superseded By

- None
