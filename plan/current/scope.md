---
title: "Scope - Prose checks"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Prose checks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000390-prose-checks
**Version:** 0.71.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- A shared rules module, `prose-rules.mjs`, that finds long sentences, blocklist words, semicolons, em dashes, and likely passive voice.
- A linter script, `prose-check.mjs`, with the commands `check`, `update`, and `diff`.
- A per-file baseline at `plan/state/prose-baseline.json` that only shrinks.
- Checks in `commit-msg`, pre-commit, the CI workflow, and the workflow template.
- A P3 docs edit pass in `ravintio-validate-and-accept`, scoped to `docs/`, READMEs, and the changelog.
- An advisory Stop hook, `check-reply-writing.mjs`, registered by `setup.sh` and `setup.ps1`.
- Updates to the hook reference, the install lifecycle list, the pack facts, and the living docs.

## Out of Scope

- Rewriting existing pack prose. Step 19 owns it.
- Archetype overrides of the standard. Step 15 owns them.
- Any change to a guard hook, and any hook that blocks a reply.
- Checks on archived records in `plan/_archive/`.

## Deferred

- Baseline path handling for the pack source move. Step 20 must rename the `ravintio-zero/` keys and read the `diff` command rules.
