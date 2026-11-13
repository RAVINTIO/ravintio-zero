---
title: "ADR 001: The plan skill scans tests by grep"
summary: "The plan agent greps the tests by hand under a skill section, with no new script."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000246-plan-checks-count-and-cap-tests"
---
# ADR-0230 - The plan skill scans tests by grep

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000246-plan-checks-count-and-cap-tests
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

Entry 0000210 asks for a plan step that names the tests holding a count, a budget, a cap or an entry id. Run 0000204 lost three test runs because the plan never named them.

## Decision

Add a Test impact scan section to the plan skill and a Test impact section to the execution plan template. The plan agent greps `ravintio-zero/tests/` and lists each match. No script runs the scan.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A scan script | Repeatable output | A new script to keep in step with test names | The test names change often and a grep adapts |
| Check in consistency-check | One gate | The check cannot know which tests a plan affects | It sees the artifacts, not the intent |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One skill, one template, one test |

## Consequences

**Positive:**
- The plan names the affected tests before P2 starts.

**Negative:**
- The plan skill grows by up to 15 lines.

**Risks:**
- The grep patterns miss a test. The scan section lists the patterns, so a maintainer can extend them.

## Related ADRs

- none

## Supersedes

- none

## Superseded By

- none
