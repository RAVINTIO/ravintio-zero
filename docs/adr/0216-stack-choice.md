---
title: "ADR-0216 - Stack choice"
status: "accepted"
component: "ravintio-zero"
feature: "0000205-initiative-skill"
---
# ADR-0216 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change adds a Markdown skill and a Node.js watch script. It edits the driver, two hooks, the orchestrator, the roadmap standards, project operations, and living docs. The design declares the stack as Node.js and Bash with the pack's test runners.

## Decision

Write the skill in Markdown and the watch script in Node.js with built-ins only. Test them from Bash suites that run the scripts and hooks against temporary repos, as the 0000043 driver suite does. Add no library or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Write the watch loop inside the skill text | No new script | The loop cannot be tested and costs model tokens | A script runs under a monitor at no token cost. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new skill, one new script, one edited script, two edited hooks, edited skills and standards, and new test suites |

## Consequences

**Positive:**
- No new dependency. The watch script costs no tokens.

**Negative:**
- Tests check skill wording, not the behaviour of a live session.

**Risks:**
- A reworded skill passes the tests but loses the rule. The tests name the exact phrases.

## Related ADRs

- ADR-0217

## Supersedes

None.

## Superseded By

None.
