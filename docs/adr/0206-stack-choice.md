---
title: "ADR-0206 - Stack choice"
status: "accepted"
component: "ravintio-zero"
feature: "0000200-reply-conventions"
---
# ADR-0206 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000200-reply-conventions
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change adds one Node.js hook, edits the Bash and PowerShell setup scripts, and edits Markdown docs. The design declares the stack as Node.js, Bash, and PowerShell with the pack's test runners.

## Decision

Write `check-reply-prefix.mjs` in Node.js ESM with built-in modules only, like the other hooks. Test it from a Bash suite. Add no library or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A Bash hook with `jq` | Short | `jq` is not on every machine, and the pack runs on Windows | The other hooks are Node.js |
| A prompt-type hook | No transcript parsing | It costs a model call on every turn | Cost with no gain over a regex |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One hook, two setup scripts, the boot template, five skills, and test suites |

## Consequences

**Positive:**
- The hook needs no library and runs wherever Node.js runs.

**Negative:**
- The hook depends on the transcript shape, which Claude Code can change.

**Risks:**
- A shape change makes the hook silent. R-001 and A-001 record this.

## Related ADRs

- ADR-0207

## Supersedes

None.

## Superseded By

None.
