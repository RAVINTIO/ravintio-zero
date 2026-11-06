---
title: "ADR 001: Stack choice"
summary: "The step adds no language, library, or service. It edits YAML, Bash tests, and Markdown skills."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000355-codeql-and-branch-cleanup
**Date:** 2026-11-06

## Context

The design declares YAML workflows, Bash tests, Markdown skills, and Bash and PowerShell setup. The chart approves no new dependency for steps 1 to 8.

## Decision

Use the declared stack. CodeQL runs as the GitHub-hosted `github/codeql-action`, which is a workflow action and not a pack dependency.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A Node script for cleanup | Testable in isolation | New script to ship and install | The `gh` CLI on the runner does the work in one command |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Workflows, tests, and skills change |

## Consequences

**Positive:**
- No new dependency to approve.

**Negative:**
- Workflow behaviour is checked by text tests, not by a run, until CI runs.

**Risks:**
- A text test passes while the workflow fails on GitHub.

## Related ADRs

- ADR-002 - related-to
- ADR-003 - related-to

## Supersedes

None.

## Superseded By

None.
