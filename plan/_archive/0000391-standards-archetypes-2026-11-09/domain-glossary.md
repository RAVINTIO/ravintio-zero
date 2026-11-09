---
title: "Domain Glossary - Standards archetypes"
summary: "Definitions of domain terms used within this feature."
status: "draft"
version: "0.1.0"
---
# Domain Glossary - Standards archetypes

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000391-standards-archetypes
**Version:** 0.1.0

> The ubiquitous language for this feature. Code, docs, and file names use these terms.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| archetype | A named bundle of override files, slots, thresholds, and gates that a team picks from `ravintio-zero/archetypes/`. | preset, profile | ravintio-zero |
| alternative | An archetype kind that swaps a pack file for another version of it. | none | ravintio-zero |
| constraint | An archetype kind that adds a gate and so narrows what the pipeline accepts. | none | ravintio-zero |
| slot | A named area that at most one installed archetype may claim, such as `stack`. | none | ravintio-zero |
| threshold | A numeric minimum that an archetype sets, such as a mutation score. No archetype may lower an installed one. | limit | ravintio-zero |
| gate | A check that P3 runs from an installed archetype. A failed gate makes `archetype-gates.mjs` exit 1. | none | ravintio-zero |
| override | A file in `ravintio-overrides/standards/` or `ravintio-overrides/templates/` that the resolver returns before the pack copy. | none | ravintio-zero |
| resolver | The script `resolve-override.mjs` that returns the path to read for a standard or template. | none | ravintio-zero |
| protected rule | A pack path in `protected.json` that a hook enforces. The resolver ignores an override that relaxes it. | enforced rule | ravintio-zero |
