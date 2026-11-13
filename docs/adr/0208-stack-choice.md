---
title: "ADR-0208 - Stack choice"
status: "accepted"
component: "ravintio-zero"
feature: "0000201-plan-concurrent-work"
---
# ADR-0208 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000201-plan-concurrent-work
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change edits Markdown templates, skills, and a standard, adds one check to a Node.js script, and adds a Bash test. The design declares the stack as Node.js and Bash with the pack's test runners.

## Decision

Extend `consistency-check.mjs` in Node.js ESM with built-in modules only. Test it from a Bash suite, like checks 6 and 7. Add no library or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A new script for the concurrency check | Isolated | The plan skill gate would run two scripts | The gate runs one script today |
| A Markdown table library | Robust parsing | A new dependency | The check parses pipe rows, as check 7 does |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One script, one template and guide, three skills or references, one standard, and one test suite |

## Consequences

**Positive:**
- The plan gate stays one command.

**Negative:**
- The pipe-row parser breaks on a unit name that holds a pipe character.

**Risks:**
- A strict table format flags a valid plan. R-001 records this.

## Related ADRs

- ADR-0209

## Supersedes

None.

## Superseded By

None.
