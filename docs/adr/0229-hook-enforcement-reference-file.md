---
title: "ADR 002: Hook Enforcement lives in a reference file"
summary: "The hook list moves from the boot templates to a standards file that block messages name."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000245-boot-rules-into-skills"
---
# ADR-0229 - Hook Enforcement lives in a reference file

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000245-boot-rules-into-skills
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

The Hook Enforcement section holds about 2,000 bytes. The agent needs it only when a hook blocks an action.

## Decision

Move the list to `ravintio-zero/standards/hook-enforcement.md`. The boot templates keep a pointer. Each blocking hook message names the file, so the agent reads it when it matters. The Codex fallback list moves there too.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Shorten the section in place | No new file | Loses detail | The detail serves the blocked agent |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Two templates, five hook messages, one new standard |

## Consequences

**Positive:**
- The boot file shrinks by about 2,000 bytes.

**Negative:**
- The agent reads a second file after a block.

**Risks:**
- A message edit could change a block decision. Tests assert exit codes stay the same.

## Related ADRs

- ADR-0228 - related-to

## Supersedes

- none

## Superseded By

- none
