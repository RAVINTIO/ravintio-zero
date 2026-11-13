---
title: "ADR 002: Run CodeQL from a workflow file"
summary: "Advanced setup scans PRs into initiative branches. Default setup cannot."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000355-codeql-and-branch-cleanup"
---
# ADR-0252 - Run CodeQL from a workflow file

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000355-codeql-and-branch-cleanup
**Date:** 2026-11-06

## Context

Default setup scans PRs into the default branch only. Alert `js/incomplete-sanitization` showed on the initiative PR and not on the step PR that shipped the flaw. Switching to a workflow turns default setup off.

## Decision

Add `.github/workflows/codeql.yml` for JavaScript and GitHub Actions, on `pull_request` into `main` and `initiative/**`. Pin actions by commit SHA where the pack already does. A human turns default setup off in repo settings before the step merges. If it is still on, the step stops for the human.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep default setup | No file to maintain | Misses step PRs | The flaw reached the initiative PR |
| Scan on push only | Covers branch heads | Finds the flaw after the merge | Too late |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New workflow, edit to entry 0000323 |

## Consequences

**Positive:**
- A finding shows on the step PR.

**Negative:**
- The pack maintains a workflow, and a human changes one repo setting.

**Risks:**
- Two CodeQL setups run at once if default setup stays on.

## Related ADRs

- ADR-0251 - related-to

## Supersedes

None.

## Superseded By

None.
