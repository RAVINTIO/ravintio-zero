---
title: "ADR 001: The stack stays as declared"
summary: "This release changes PowerShell scripts and Markdown only, inside the declared stack."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000171-faster-setup-ps1-tests"
---
# ADR-0181 - The stack stays as declared

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000171-faster-setup-ps1-tests
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

The design declares PowerShell 5.1 and 7, Bash, and Markdown. The roadmap approves no new dependency for step 3.

## Decision

The faster copy uses .NET types that both PowerShell hosts load by default. No module or tool such as `robocopy` joins the pack.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| `robocopy` | Fast bulk copy on Windows | Windows only, and its exit codes differ from the usual 0 for success | `pwsh` on Linux and macOS has no `robocopy` |
| A Node.js copy script | One copy for both setup scripts | Setup would need Node.js before it checks for it | Changes the install order |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Script changes only, no new dependency |

## Consequences

**Positive:**
- The pack keeps its zero-dependency install.

**Negative:**
- `setup.ps1` holds its own small copy helper.

**Risks:**
- None beyond the risk register.

## Related ADRs

- ADR-0182

## Supersedes

- None

## Superseded By

- None
