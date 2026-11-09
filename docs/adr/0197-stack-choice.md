---
title: "ADR 001: Stack choice"
summary: "The feature keeps the pack's declared stack and adds no dependency."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000192-rename-runner-lock-and-archive"
---
# ADR-0197 - Stack choice

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000192-rename-runner-lock-and-archive
**Component:** ravintio-zero
**Date:** 26 Oct 2026

## Context

The design declares the pack's existing stack: Markdown, Node.js ESM, Bash 3.2, and PowerShell 5.1 and 7. The feature changes one driver constant, one delivery check, one standards line, and tests. The approved dependency list is empty.

## Decision

The feature uses the declared stack only and adds no library, package, or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| None | | | The change fits the existing driver and tests |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | No new runtime or tool |

## Consequences

**Positive:**
- Consumers install nothing new.

**Negative:**
- None beyond the existing stack's limits.

**Risks:**
- None
