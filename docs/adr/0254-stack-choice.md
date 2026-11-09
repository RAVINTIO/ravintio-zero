---
title: "ADR 001: Stack choice"
summary: "The step adds no language, library, or service. It edits Node hooks, Bash and PowerShell setup, and Bash tests."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000357-guard-gaps-closed"
---
# ADR-0254 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000357-guard-gaps-closed
**Date:** 2026-11-06

## Context

The design declares Node hooks, Bash and PowerShell setup, and Bash tests. The chart approves no new dependency for steps 1 to 8.

## Decision

Use the declared stack. The wrapper is shell text in the hook command, so it adds no file to install.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A Node wrapper script | Same on every shell | It is a second file that can go missing | It repeats the gap it closes |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Hooks, setup, tests, and one standard change |

## Consequences

**Positive:**
- No new dependency to approve.

**Negative:**
- The hook command now needs a POSIX shell.

**Risks:**
- A shell that lacks `||` fails to parse the command. ADR-0255 covers it.

## Related ADRs

- ADR-0255 - related-to
- ADR-0256 - related-to

## Supersedes

None.

## Superseded By

None.
