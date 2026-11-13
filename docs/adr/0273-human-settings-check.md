---
title: "ADR 003: Human-only settings check"
summary: "A script reads allowlisted repository settings with GET and blocks P1 on a mismatch."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000384-plan-checks"
---
# ADR-0273 - Human-only settings check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000384-plan-checks
**Component:** ravintio-zero
**Date:** 08 Nov 2026

## Context

Backlog entry 0000364 notes that a step found a human-only setting wrong at P3, after it wrote all its code. The entry leaves open which settings the plan skill may read.

## Decision

- A chart names a setting as a `## Decisions` row with Fork `Human setting: {name}` and answer `GET {endpoint} {jq-path}={expected}`.
- `human-settings-check.mjs` runs `gh api -X GET` through `execFileSync` with an argument array.
- The endpoint must match the allowlist: `repos/{owner}/{repo}` and its `code-scanning/default-setup`, `vulnerability-alerts`, `private-vulnerability-reporting`, `automated-security-fixes`, `rulesets`, and `branches/{branch}/protection` paths. Any other endpoint exits 1.
- The script only reads. It writes no setting.
- Oldest shell: Bash 3.2. The script is Node.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Let the plan skill run any `gh api` call | Flexible | Opens a write path | Violates the read-only rule |
| Check at P3 only | No new script | The late failure that the entry reports | Same defect |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | A new script, a plan skill step, and a chart format row |

## Consequences

**Positive:**
- A wrong setting blocks before P2.

**Negative:**
- A new chart row format to learn.

**Risks:**
- A chart row holds a hostile endpoint. The allowlist and the array call contain it.

## Related ADRs

- ADR-0271 - related-to

## Supersedes

- None

## Superseded By

- None
