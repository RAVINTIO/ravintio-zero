---
title: "ADR 003: Uninstall from manifest and markers"
summary: "Uninstall removes manifest paths and RAVINTIO-marked entries, and nothing else."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000382-install-lifecycle"
---
# ADR-0330 - Uninstall from manifest and markers

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
- The folders and files in the skills and commands manifests, with the confinement check from step 5. A skill folder goes only if the pack or the capability skills name it.
- `.github/workflows/ravintio.yml` and `.gitattributes`, only when they match the pack copy.
- The strict-mode marker, the acknowledgement marker, and the setup-flag marker.

It refuses while `plan/.orchestrator-active` or `plan/.initiative-runner.lock` exists. It deletes no record under `plan/` and lists the records. It keeps `CLAUDE.md` and the `env`, `allowedTools`, and `attribution` values that setup set, and lists them.

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

- ADR-0328 - related-to

## Supersedes

- None

## Superseded By

- None
