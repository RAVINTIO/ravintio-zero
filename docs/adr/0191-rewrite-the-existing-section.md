---
title: "ADR 001: Rewrite the existing strict mode section"
summary: "The run rewrites the strict mode section in place, adds no dependency, and keeps the stack as declared."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000185-explain-strict-mode"
---
# ADR-0191 - Rewrite the existing strict mode section

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000185-explain-strict-mode
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

Backlog entry 0000184 asks for a new subsection after the **Orchestrator Sentinel** table in `project-operations.md`. That file already holds a `## Strict Orchestrator Mode` section in that place. A second section would repeat the flag and the setup commands. The roadmap's dependency table lists `none` for step 6.

## Decision

Rewrite the body of `## Strict Orchestrator Mode` from the entry's draft and keep the heading. Point the two links at its anchor. Correct the draft where it differs from the hook. The hook acts only while `plan/.orchestrator-active` exists. It asks for a timestamp when it has no session id. The stack stays Markdown and Bash, with no new dependency.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add the subsection as the entry drafts it | Matches the entry word for word | Two sections cover the same flag | Duplicate text drifts apart |
| Change only `pipeline-reference.md` | That file already has an ack subsection | Readers of `project-operations.md` still miss it | The entry's wanted outcome names `project-operations.md` |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Docs change and one new suite |

## Consequences

**Positive:**
- One section explains strict mode, and the existing anchor keeps working.

**Negative:**
- `pipeline-reference.md` keeps its own shorter account, so the two files still overlap.

**Risks:**
- None beyond the risk register.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
