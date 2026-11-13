---
title: "ADR 002: Compare tool and flags, not the timestamp"
summary: "Setup rewrites the tracked record only when tool or flags differ."
status: "active"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000354-steps-run-to-the-end"
---
# ADR-0250 - Compare tool and flags, not the timestamp

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0
**Component:** ravintio-zero
**Date:** 2026-11-06

## Context

Setup rewrites `writtenAt` in the tracked record on every run. Each `Setup:` stop then needs a PR for one timestamp. Entry 0000343 describes it.

## Decision

Setup reads the existing record and compares `tool` and `flags`. If both match, it leaves the file alone. The ignored marker keeps its timestamp, so the "when was setup last run" signal stays local.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Move `writtenAt` to an ignored file | Keeps the field | Changes the record format and its readers | Larger change |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `setup.sh`, `setup.ps1`, and one existing test. |

## Consequences

**Positive:**
- A rerun leaves a clean tree.

**Negative:**
- The tracked `writtenAt` no longer shows the last run.

**Risks:**
- See R-003.

## Related ADRs

- ADR-0249 - related

## Supersedes

- None.

## Superseded By

- None.
