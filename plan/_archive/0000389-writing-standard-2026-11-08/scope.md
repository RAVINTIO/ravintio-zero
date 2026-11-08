---
title: "Scope - Writing standard"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Writing standard

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Version:** 0.61.0

## In Scope

- `standards/writing-standards.md` with a `style-rules` and a `summary` region
- `scripts/writing-style.mjs` for `claude-code` and `codex`
- Setup in `setup.sh` and `setup.ps1`: output style file, `outputStyle`, Codex `AGENTS.md` section, and `--no-writing-style`
- `ravintio-refresh-setup` accepts `--no-writing-style`
- Date and semicolon agreement in `formatting-standards.md`, and the `em-dash-guard.mjs` message
- The standard named in the dispatch template and in the step session arguments
- Docs, `component.yml`, and tests for each change

## Out of Scope

- Rewriting existing pack prose or dates (step 19)
- A prose linter (step 14)
- Archetype overrides (step 15)
- A migration for existing installs. A setup rerun installs the outputs.

## Deferred

- Archetype overrides of the standard. Step 15 is blocked until this step merges.
