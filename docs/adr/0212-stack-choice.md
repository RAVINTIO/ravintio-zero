---
title: "ADR-0212 - Stack choice"
status: "accepted"
component: "ravintio-zero"
feature: "0000203-blameless-postmortems"
---
# ADR-0212 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000203-blameless-postmortems
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change adds a Markdown skill and a template, edits two skills and a catalogue, and adds Bash tests. The design declares the stack as Node.js and Bash with the pack's test runners.

## Decision

Write the skill and template in Markdown. Test them from Bash suites that read the files, like the 0000202 suites. Add no script, library, or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A script that detects triggers and writes records | Fewer missed stops | A new script to maintain, and a postmortem needs judgement | Out of scope. The orchestrator reads the build log lines. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new skill, one template, two edited skills, one catalogue, three docs, and three test suites |

## Consequences

**Positive:**
- No new dependency and no new script to maintain.

**Negative:**
- Tests check the wording of the skill, not the behaviour of a run.

**Risks:**
- A reworded skill passes the tests but loses the rule. The tests name the exact phrases.

## Related ADRs

- ADR-0213

## Supersedes

None.

## Superseded By

None.
