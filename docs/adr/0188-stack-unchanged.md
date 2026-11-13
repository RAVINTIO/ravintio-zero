---
title: "ADR 001: The stack stays as declared"
summary: "The metrics script uses Node built-in modules only, and the pack gains no dependency."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000173-workflow-governance-gates"
---
# ADR-0188 - The stack stays as declared

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000173-workflow-governance-gates
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

The pack already ships Node scripts under `ravintio-zero/scripts/`, such as `consistency-check.mjs` and `product-version.mjs`. Each uses built-in modules only. The roadmap's dependency table lists `none` for step 5.

## Decision

`workflow-metrics.mjs` uses `node:fs` and `node:path` only. Bash suites test it, as they test the other scripts.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A Markdown parser library | Robust table parsing | A new dependency the chart did not approve | The marker and table forms are fixed, so line matching suffices |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new script and one new suite per requirement |

## Consequences

**Positive:**
- Consumers install nothing new.

**Negative:**
- The script parses one table form only. A reformatted table fails the run with a named key.

**Risks:**
- None beyond the risk register.

## Related ADRs

- ADR-0189, ADR-0190

## Supersedes

- None

## Superseded By

- None
