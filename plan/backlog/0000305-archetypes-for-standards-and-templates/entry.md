---
title: "Backlog Entry: 0000305 - archetypes for standards and templates"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000305 - archetypes for standards and templates

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Overrides cover five areas: `instructions`, `capability-skills`, `library-standards`, `setup-config`, and `loop-toggles`. Only `library-standards` follows an override-first rule (`ravintio-implement/SKILL.md:52`).

Standards and templates have no override path. A team that wants a US writing style, a fixed stack, or stricter testing can only edit the pack. Entry 0000299 makes setup refuse that edit.

## Suggested Action

- Add a catalogue at `ravintio-zero/archetypes/`, with one folder per archetype and a README that says what each changes.
- Support two kinds:
  - An alternative changes wording or format. It can't relax a rule that a hook enforces.
  - A constraint adds rules. It may tighten any gate and never loosens one.
- Let an archetype carry standards, templates, P3 gate criteria, CI steps, and setup config, such as an MCP server entry. A constraint counts only if a gate enforces it.
- Make every standard and template override-first. A shared resolver checks `ravintio-overrides/standards/` and `ravintio-overrides/templates/` before the pack copy. The resolver ignores an override of a hook-enforced rule.
- Add a command such as `setup.sh archetype use {kind}/{name}`. It copies the archetype into overrides and prints what it replaced. The developer then commits it.
- Allow several archetypes at once. The command reports a clash, such as two stack lists, and makes the developer choose. No archetype can lower another's threshold.
- Generate the output style and `AGENTS.md` section from the picked writing archetype (entry 0000300).
- Ship four archetypes first:
  - **US writing style.** It replaces the writing standard, and the linter switches to US spelling.
  - **Restricted architecture and stack.** It lists the allowed stacks, components, and libraries. P0 offers only those, and the design gate fails on anything else.
  - **Language standards.** It adds coding standards for one language, beside `library-standards/{language}/`, and names the linters and formatters CI runs.
  - **Strict testing.** It adds P3 gates for Pact contract tests between components, a minimum mutation score with a tool such as Stryker or PIT, and Playwright MCP for UI acceptance checks.

## Wanted outcome

A team can pick tested alternatives and constraints without editing the pack, and no pick weakens a guard. Tests check these conditions:

- With an override template in `ravintio-overrides/templates/`, the resolver returns it before the pack copy.
- The resolver ignores an override that relaxes a hook-enforced rule.
- Picking two archetypes with different stack lists reports the clash and copies nothing.
- With the strict testing archetype, P3 fails when a component API has no Pact contract.

## Why Deferred

The human asked for it on 2026-10-31, from a review of Zero's writing quality. No run is active.
