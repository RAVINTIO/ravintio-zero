---
title: "ADR 001: The stack stays as declared"
summary: "The release changes Markdown skills, standards, and templates, and adds Bash text suites, with no new dependency."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000172-subagent-acceleration"
---
# ADR-0185 - The stack stays as declared

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000172-subagent-acceleration
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

The design declares Markdown and Bash with a local build target. The roadmap lists no dependency for step 4.

## Decision

The release edits skill, standard, and template text and adds Bash suites under `ravintio-zero/tests/`. It adds no library, service, script, or hook.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A script that times each phase | Exact times | A new script and hook for data the agent can write | The build log already holds a `Start` time |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Text changes only |

## Consequences

**Positive:**
- No install or runtime change for consumers.

**Negative:**
- The agent writes the times, so a phase can miss its `End` row.

**Risks:**
- None beyond the risk register.

## Related ADRs

- ADR-0186, ADR-0187

## Supersedes

- None

## Superseded By

- None
