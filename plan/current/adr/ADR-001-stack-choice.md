---
title: "ADR 001: Stack choice"
summary: "The step adds no language, library, or service. It edits skills, Node scripts, and Bash and PowerShell runners."
status: "active"
version: "0.1.0"
---
# ADR-001 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000358-clean-step-stops-and-logs
**Version:** 0.55.0
**Date:** 2026-11-07

## Context

The design declares Bash, Node, and PowerShell. The chart approves no dependency for steps 1 to 8.

## Decision

Use the declared stack. The time check calls `git` through `node:child_process` to run `git blame`, as other scripts here do.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A git library | Richer history access | A new dependency | The chart approves none |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero pack | Skills, one script, two runners, a hook comment, tests |

## Consequences

- Positive: no dependency or install change.
- Negative: without a `git` binary the time check compares each time with the clock.
