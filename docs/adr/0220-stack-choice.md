---
title: "ADR-0220 - Stack choice"
status: "accepted"
component: "ravintio-zero"
feature: "0000207-codex-support"
---
# ADR-0220 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000207-codex-support
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change edits shell and PowerShell setup scripts, adds a template, and adds tests. The design declares Bash, PowerShell, Node.js, and Markdown.

## Decision

Extend the existing setup scripts with a tool config per harness. Add no script, library, or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A separate setup script for Codex | No risk to the Claude Code path | Duplicates the shared install logic | Two copies drift. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Two tool configs, one boot template, setup edits, and tests |

## Consequences

**Positive:**
- No new dependency.

**Negative:**
- The shared scripts keep some Claude Code paths for the hook install.

**Risks:**
- A shared change could regress Claude Code. Existing suites run unchanged.

## Related ADRs

- ADR-0221

## Supersedes

None.

## Superseded By

None.
