---
title: "Scope - Pack source in src"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Pack source in src

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000397-pack-source-in-src
**Version:** 0.76.0

## In Scope

- A pure `git mv ravintio-zero src/ravintio-zero` commit, then a plain copy back to `ravintio-zero/`.
- Tests that find the repo by `git rev-parse --show-toplevel` and the pack by their own location.
- CI checks, scripts, and guards that cover `src/ravintio-zero/`.
- A `sync-installed.mjs` script that copies the source to the installed folder and checks parity.
- Docs for the layout and the refresh route, and a `component.yml` for the source.

## Out of Scope

- Any change to a file format, a hook rule, or a consumer install path.
- A symlink between the folders.
- Step 21 activation work.
- Consumer installs from the source. They keep the `ravintio-zero/` path.

## Deferred

Nothing deferred.
