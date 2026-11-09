---
title: "ADR 001: Confine manifest removal"
summary: "Setup removes a manifest entry only if it is a direct child of the skills directory."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000381-setup-safety"
---
# ADR-0268 - Confine manifest removal

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000381-setup-safety
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

The manifest lists absolute paths, and setup runs `rm -rf` on each one. A copied repo carries a manifest that points at the real folders (backlog 0000262).

## Decision

The manifest holds paths relative to the repo root. Setup resolves each line under `$PROJECT_ROOT`. It accepts a legacy absolute line only if the same rule passes. A line passes if it has no `..` segment, is not a symlink, and its physical parent equals the physical skills directory. Setup warns and skips every other line. The test runner also lists `.claude/skills/` before and after the full run.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Prune by name only | No manifest needed | Cannot remove a folder the pack renamed | Loses the rename case |
| Keep absolute paths and add the check | No format change | A copied manifest still names the real tree | Leaves the cause in place |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `setup.sh`, `setup.ps1`, migrations, and tests change |

## Consequences

**Positive:**
- A copied repo cannot reach the real tree.
- A bad line costs one warning.

**Negative:**
- Legacy manifests rewrite on the next run.

**Risks:**
- See the risk register.

## Related ADRs

- ADR-0269 - related-to

## Supersedes

- None

## Superseded By

- None
