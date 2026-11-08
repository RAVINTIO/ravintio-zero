---
title: "ADR 003: Uninstall from manifest and markers"
summary: "Uninstall removes manifest paths and RAVINTIO-marked entries, and nothing else."
status: "accepted"
version: "0.1.0"
---
# ADR-003 - Uninstall from manifest and markers

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Component:** ravintio-zero
**Date:** 2026-11-08

## Context

Setup writes to git config, `.claude/settings.json`, the workflow, `.gitattributes`, and several folders. Uninstall is a widening of a fail-closed guard surface, and the chart approves it with conditions.

## Decision

Uninstall removes only these items. It prints each one it removes.

- The `core.hooksPath` setting, when it points at `ravintio-zero/hooks`.
- Hook entries in `.claude/settings.json` whose command points at `.claude/hooks/enforcement/`.
- The folders and files in the skills and commands manifests, with the confinement check from step 5.
- `.github/workflows/ravintio.yml` and `.gitattributes`, only when they match the pack copy.
- The strict-mode and setup-flag markers.

It refuses while `plan/.orchestrator-active` or `plan/.initiative-runner.lock` exists. It deletes nothing under `plan/` and lists the records.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Remove everything setup could write | Thorough | Risks developer files | Breaks the keep-my-work outcome |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Setup scripts, docs, tests |

## Consequences

**Positive:**
- A developer can leave Zero cleanly.

**Negative:**
- A file the developer edited after setup stays and gets listed.

**Risks:**
- See the risk register.

## Related ADRs

- ADR-001 - related-to

## Supersedes

- None

## Superseded By

- None
