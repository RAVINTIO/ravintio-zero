---
title: "ADR-0207 - A warn-only Stop hook"
status: "accepted"
component: "ravintio-zero"
feature: "0000200-reply-conventions"
---
# ADR-0207 - A warn-only Stop hook

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000200-reply-conventions
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

Replies lack prefixes after compaction, and nothing checks them. The backlog entry asks for a `Stop` hook that starts as a warning, with misses logged so the rate can be measured. A blocking `Stop` hook makes the agent continue and rewrite the reply, which can loop.

## Decision

The hook warns through `systemMessage`, appends a line to `plan/.prefix-misses.log`, and always exits 0. The pack hardens it only after the log shows the rate. The boot file also carries the rule, because the hook warns the human and does not teach the agent.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Block with exit 2 | The agent corrects the reply | A false positive loops the turn | The backlog entry asks for a warning first |
| Boot file only | No hook code | No measure of the miss rate | The entry asks for a measure |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One hook and one untracked log |

## Consequences

**Positive:**
- A false positive costs one warning and never stops a turn.

**Negative:**
- The agent receives no correction from the warning.

**Risks:**
- Nobody reads the log. The human decides when to harden the hook.

## Related ADRs

- ADR-0206

## Supersedes

None.

## Superseded By

None.
