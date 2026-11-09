---
title: "ADR 001: Stack choice"
summary: "The step adds no language, library, or service. It edits Markdown rules and Bash tests."
status: "active"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000359-safe-parallel-commits"
---
# ADR-0258 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000359-safe-parallel-commits
**Version:** 0.56.0
**Date:** 2026-11-07

## Context

The design declares Markdown and Bash. The chart approves no dependency for steps 1 to 8.

## Decision

Use the declared stack. Write the rules as skill and standard text, and check them with Bash suites that read the files.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A blocking hook | Enforces the rule | A new guard, outside the entries | The entries ask for text rules |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero pack | Two skills, one standard, two tests |

## Consequences

- Positive: no dependency or install change.
- Negative: a text rule does not stop a unit that ignores it.
