---
title: "ADR 001: The stack stays as declared"
summary: "This release adds two Node.js scripts and a CI job, inside the declared stack."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000169-release-hygiene"
---
# ADR-0173 - The stack stays as declared

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000169-release-hygiene
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

The design declares Bash, PowerShell, Node.js ESM, Markdown, and GitHub Actions YAML. The roadmap approves no new dependency for step 1.

## Decision

Both new scripts use Node.js built-ins only. The CI job uses `actions/checkout` and the `git` and `node` that `ubuntu-latest` ships. No library or service joins the pack.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A tagging action from the Marketplace | Less code to own | A new third-party dependency with write access | Not on the approved list |
| Bash scripts | No Node.js needed | No native Windows run, unlike the other pack scripts | Node.js matches `product-version.mjs` |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Two scripts and a CI job, no new dependency |

## Consequences

**Positive:**
- The pack keeps its zero-dependency install.

**Negative:**
- The pack owns the tag logic and its tests.

**Risks:**
- None beyond the risk register.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
