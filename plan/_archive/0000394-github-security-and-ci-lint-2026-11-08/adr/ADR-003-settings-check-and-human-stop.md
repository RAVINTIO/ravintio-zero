---
title: "ADR 003: Settings check script and the human stop"
summary: "A script lists and checks the admin-only settings, and the step stops once for the human at P3."
status: "accepted"
version: "0.1.0"
---
# ADR-003 - Settings check script and the human stop

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000394-github-security-and-ci-lint
**Component:** ravintio-zero
**Date:** 2026-11-08

## Context

Secret scanning, push protection, Dependabot security updates, private vulnerability reporting, and topics need repo admin rights. A step session has none. The chart row for step 18 says the step prints a checklist and waits.

## Decision

`ravintio-zero/scripts/github-settings.mjs` has a `list` command and a `check` command. `check` reads `repos/{repo}` for `security_and_analysis`, `repos/{repo}/private-vulnerability-reporting`, `repos/{repo}/topics`, and `repos/{repo}/rules/branches/main` for the `workflow-lint` required check. The step builds everything first. At P3 it prints the checklist and stops with `P3 Validate: Question:`. After the human acts, the resumed session runs `check`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Stop at P0 | Human acts early | The required check cannot name a job that does not exist yet | The job must land first |
| Set the settings from the step | No human wait | Needs admin rights the session lacks | Hard Limit 6 and the chart row |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One script and a doc |

## Consequences

**Positive:**
- The settings state is checkable at any time.

**Negative:**
- The step waits for a human.

**Risks:**
- A token without admin rights cannot read `security_and_analysis`. The script reports that item as `unknown` and exits 1.

## Related ADRs

- ADR-002 - related-to

## Supersedes

- None

## Superseded By

- None
