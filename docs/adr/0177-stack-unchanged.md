---
title: "ADR 001: The stack stays as declared"
summary: "This release changes Node.js scripts and Markdown only, inside the declared stack."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000170-story-mapping-and-gherkin"
---
# ADR-0177 - The stack stays as declared

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000170-story-mapping-and-gherkin
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

The design declares Node.js ESM, Bash, and Markdown. The roadmap approves no new dependency for step 2.

## Decision

The consistency check and the ratchet hook parse Gherkin with Node.js built-ins and regular expressions. No Gherkin parser library joins the pack.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| The `@cucumber/gherkin` parser | Full Gherkin grammar | A new dependency for a few line rules | Not on the approved list |
| A Bash checker | No Node.js needed | Duplicates parsing the Node.js check already does | The check is already Node.js |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Script changes only, no new dependency |

## Consequences

**Positive:**
- The pack keeps its zero-dependency install.

**Negative:**
- The pack owns a small Gherkin subset parser and its tests.

**Risks:**
- None beyond the risk register.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
