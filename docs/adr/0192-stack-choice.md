---
title: "ADR 001: Stack choice"
summary: "The feature keeps the pack's declared stack and adds no dependency."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000189-name-the-roadmap-initiative"
---
# ADR-0192 - Stack choice

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Component:** ravintio-zero
**Date:** 26 Oct 2026

## Context

The design declares the pack's existing stack: Markdown, Node.js ESM, Bash 3.2, and PowerShell 5.1 and 7, with GitHub Actions CI. The feature renames files and strings, adds one migration, and adds one search test. The approved dependency list in `design.md` is empty.

## Decision

The feature uses the declared stack only. The migration helpers ship as a Bash script and a PowerShell script, like migration 0004. The guard test is a Bash test under `ravintio-zero/tests/`, and the existing runners pick it up. The feature adds no library, package, or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A Node-only migration helper | One script for both shells | Breaks the pattern of migration 0004, which ships Bash and PowerShell helpers | Consistency with prior migrations |
| A third-party search tool such as ripgrep for the guard | Faster search | Not installed on every CI runner. It would also need dependency approval | `git grep` covers the need |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | No new runtime or tool. New files follow existing patterns. |

## Consequences

**Positive:**
- Consumers install nothing new.
- The dependency exception stop cannot fire for this feature.

**Negative:**
- Each migration helper exists twice, once per shell, so both copies need tests.

**Risks:**
- The Bash and PowerShell helpers drift apart. The REQ-005 test runs both on the same fixture.

## Related ADRs

- ADR-0193 - related-to
- ADR-0196 - related-to

## Supersedes

- None

## Superseded By

- None
