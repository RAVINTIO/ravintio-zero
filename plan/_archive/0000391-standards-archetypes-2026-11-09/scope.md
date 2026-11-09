---
title: "Scope - Standards archetypes"
summary: "Defines what the archetype feature delivers, excludes, and defers."
status: "draft"
version: "0.1.0"
---
# Scope - Standards archetypes

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Version:** 0.1.0

## In Scope

- The resolver `ravintio-zero/scripts/resolve-override.mjs`, which returns an override from `ravintio-overrides/standards/` or `ravintio-overrides/templates/` before the pack copy.
- The protected-rule list `ravintio-zero/archetypes/protected.json`.
- The catalogue `ravintio-zero/archetypes/` with a README and four archetypes: US writing, restricted stack, language standards, and strict testing.
- `archetype list` and `archetype use {kind}/{name}` in `ravintio-zero/scripts/archetype.mjs`, dispatched from `setup.sh` and `setup.ps1`.
- The slot clash check, the file clash check, and the threshold check.
- The P3 gate check `ravintio-zero/scripts/archetype-gates.mjs` and the validate-and-accept pointer to it.
- A `writing-style.mjs` change so the output style and `AGENTS.md` section follow the writing pick.
- The standard `ravintio-zero/standards/archetype-standards.md`, living docs, the component manifest, and tests.

## Out of Scope

- Installing Pact, Stryker, PIT, or Playwright MCP. The strict-testing archetype only names them.
- Any hook change that allows a form the hook blocks today.
- Rewriting existing standards. Step 19 owns the prose pass.
- Any edit to the orchestrator `SKILL.md`, which has 77 bytes of headroom.
- Spelling lint. The prose check tests no spelling.

## Deferred

- An archetype uninstall command. Blocked: nothing. A developer deletes the copied files and the record entry by hand.
- Latency, availability, and scalability targets. The design defers them because the feature runs no service. Blocked: nothing.
