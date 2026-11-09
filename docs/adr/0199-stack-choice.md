---
title: "ADR 001: Stack choice"
summary: "The feature stays in Bash and PowerShell with the pack's own test suites, and adds no dependency."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000196-setup-argument-checks"
---
# ADR-0199 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000196-setup-argument-checks
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change edits `setup.sh` and `setup.ps1`, the tests for both, and one skill. The design declares the stack as Bash and PowerShell with the pack's test runners.

## Decision

Use Bash and PowerShell only. Add tests to `run-tests.sh` and `run-tests.ps1` suites. Add no library or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Share parsing in a Node helper | One implementation | Setup would need Node before it runs | New dependency, and setup must run without it |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Edits to two setup scripts, tests, and one skill |

## Consequences

**Positive:**
- No new dependency to approve or install.

**Negative:**
- Each rule exists twice, so the two shells can drift.

**Risks:**
- Drift in error text. Parity assertions in both suites cover it.

## Related ADRs

- ADR-0200 - related-to

## Supersedes

None.

## Superseded By

None.
