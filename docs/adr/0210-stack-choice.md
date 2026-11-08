---
title: "ADR-0210 - Stack choice"
status: "accepted"
component: "ravintio-zero"
feature: "0000202-improvement-loops"
---
# ADR-0210 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000202-improvement-loops
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change edits Markdown skills and a standard, and adds Bash tests. The design declares the stack as Node.js and Bash with the pack's test runners.

## Decision

Edit the skills and the standard in Markdown. Test them from Bash suites that read the files, like the 0000201 suites. Add no script, library, or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A script that counts cycles per requirement | A measured gain | A threshold has no stated value | Out of scope. The markers keep the data for a later release. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Two skills, one standard, three docs, and two test suites |

## Consequences

**Positive:**
- No new dependency and no new script to maintain.

**Negative:**
- Tests check the wording of the skills, not the behaviour of a run.

**Risks:**
- A reworded skill passes the tests but loses the rule. R-003 covers churn only. The tests name the exact phrases.

## Related ADRs

- ADR-0211

## Supersedes

None.

## Superseded By

None.
