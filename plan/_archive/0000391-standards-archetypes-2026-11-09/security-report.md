# Security Report - Standards archetypes

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Version:** 0.74.0

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | informational | injection | ravintio-zero | `scripts/archetype-gates.mjs` joins the gate `report` and `path` values from an archetype manifest onto the repo root with no traversal check. The manifest comes from the pack or from the consumer's own `ravintio-overrides/`, so the reader already trusts it. | Reject a gate path that leaves the root if a later feature lets a third party supply manifests. | accepted |
| S-002 | informational | config | ravintio-zero | `scripts/archetype.mjs` copies files into `ravintio-overrides/` and refuses a symlink at any destination or parent. It rejects a pick name with `..`, an absolute path, or a separator. | None. A test covers each case. | mitigated |
| S-003 | informational | config | ravintio-zero | `scripts/resolve-override.mjs` falls back to the pack copy for a symlink, a traversal name, or a relaxed protected rule. | None. A test covers each case. | mitigated |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none (Node built-ins only) | n/a | none | low | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| An override relaxes a hook-enforced rule | A copied archetype file or a hand-written override | ravintio-zero | medium | high | `archetypes/protected.json` and the resolver ignore or pin the rule | None found |
| An archetype overwrites the developer's own override | `archetype use` on a file the developer edited | ravintio-zero | medium | medium | The command stops with a `clash:` line and writes nothing | None found |
| A symlink redirects a copy outside the repo | A planted link under `ravintio-overrides/` | ravintio-zero | low | high | The command refuses a symlink at the destination and at each parent | None found |

## Risk register cross-check

The plan names two risks. The protected list mitigates an override that relaxes a rule. One Node script and a parity test mitigate setup script drift. Neither is open.

## Recommendations

1. Add a root check to the gate paths if a later feature lets a third party supply manifests.
