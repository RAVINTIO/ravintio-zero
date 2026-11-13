---
title: "Archetypes"
summary: "The catalogue of starter archetypes that change the standards and gates your team follows."
status: "active"
version: "0.1.0"
---
# Archetypes

An archetype is a ready-made set of standards, templates, and gates. Each one lives at `archetypes/{kind}/{name}/` with an `archetype.json` manifest and a `files/` folder. The `files/` folder mirrors `ravintio-overrides/`.

## Kinds

- `alternative` swaps a pack default for another. Two alternatives can't claim the same slot.
- `constraint` adds rules and gates on top of the pack. A constraint never replaces a default.

Language standards is an alternative because it replaces the language standards the pipeline reads. A constraint only adds.

## Catalogue

| Archetype | Kind | Slot | What it changes |
|-----------|------|------|-----------------|
| `us-writing` | alternative | `writing-style` | Swaps British spelling for American spelling. It keeps every protected rule. |
| `restricted-stack` | constraint | `stack-list` | Adds an allowlist gate over the stack in `design.md`. |
| `language-standards` | alternative | `language-standards` | Swaps the language standards for your linter and formatter rules. |
| `strict-testing` | constraint | `strict-testing` | Adds a Pact contract gate and a mutation score gate of 80. |

The US archetype content uses American spelling. The rest of the pack uses British spelling.

## Pick an archetype

1. Run `setup.sh archetype list` to see the four archetypes.
2. Run `setup.sh archetype use {kind}/{name}`, for example `setup.sh archetype use constraint/strict-testing`.
3. Edit the installed files under `ravintio-overrides/` to fit your team.

## Tools the pack does not install

The `strict-testing` archetype names Pact, Stryker or PIT, and Playwright MCP. The pack installs none of them. You install them in your project.
