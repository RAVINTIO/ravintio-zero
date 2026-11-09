---
title: "ADR-0214 - Stack choice"
status: "accepted"
component: "ravintio-zero"
feature: "0000204-run-and-initiative-retrospectives"
---
# ADR-0214 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000204-run-and-initiative-retrospectives
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change adds a Markdown skill and a template, edits the ship skill, the orchestrator, the roadmap standards, and a catalogue, and adds Bash tests. The design declares the stack as Node.js and Bash with the pack's test runners.

## Decision

Write the skill and template in Markdown. Test them from Bash suites that read the files, like the 0000203 suites. Add no script, library, or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A script that gathers build-log data and writes records | Fewer missed fields | A new script to maintain, and a retrospective needs judgement | Out of scope. The skill reads the build log. |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new skill, one template, three edited files, one catalogue, three docs, and four test suites |

## Consequences

**Positive:**
- No new dependency and no new script to maintain.

**Negative:**
- Tests check the wording of the skill, not the behaviour of a run.

**Risks:**
- A reworded skill passes the tests but loses the rule. The tests name the exact phrases.

## Related ADRs

- ADR-0215

## Supersedes

None.

## Superseded By

None.
