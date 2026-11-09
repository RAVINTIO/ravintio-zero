---
title: "ADR-0218 - Stack choice"
status: "accepted"
component: "ravintio-zero"
feature: "0000206-chart-time-decisions"
---
# ADR-0218 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000206-chart-time-decisions
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change edits a standards file, a template, and two skills, and adds a Bash test. The design declares Markdown and Bash.

## Decision

Write the rules in Markdown and test them from a Bash suite that reads the files. Add no script, library, or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A script that validates the tables | Catches a malformed row | A new script to maintain | Out of scope. Chart builds the tables with the human. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One standards section, one template, two skill lines, and one test suite |

## Consequences

**Positive:**
- No new dependency and no new script.

**Negative:**
- Tests check wording, not the behaviour of a run.

**Risks:**
- A reworded rule passes the tests but loses meaning. The tests name exact phrases.

## Related ADRs

- ADR-0219

## Supersedes

None.

## Superseded By

None.
