---
title: "ADR 001: Stack choice"
summary: "The feature stays in Node.js and Bash with the pack's own test suites, and adds no dependency."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000198-cap-echoed-plan-text"
---
# ADR-0202 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000198-cap-echoed-plan-text
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change edits how two Node.js programs build output text, and adds a Bash test suite. The design declares the stack as Node.js and Bash with the pack's test runners.

## Decision

Edit `ratchet-check.mjs` and `consistency-check.mjs` and add one Bash suite. Change echoed text only and leave control flow alone. Add no library or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add a text utility library | Tested truncation | A new dependency for one line of code | The Dependencies table lists none |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Two programs, one test suite, and docs |

## Consequences

**Positive:**
- A long or hostile line cannot flood the agent's context from these two programs.

**Negative:**
- The agent sees a cut line and must open the file to read the rest.

**Risks:**
- An edit could touch control flow. The existing suites guard the exit codes.

## Related ADRs

- ADR-0203

## Supersedes

None.

## Superseded By

None.
