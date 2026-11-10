---
title: "Scope - the version bump writes both pack copies"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - the version bump writes both pack copies

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000420-version-both-copies
**Version:** 0.76.0

## In Scope

- The `? ` prefix and `presentPaths` in `version-files.mjs`.
- `? src/ravintio-zero/component.yml` in the shipped list.
- The queue stages present files only.
- One new suite and an update to the 0000378 list test.
- A changelog entry. No version bump, because this PR is not a chart step.

## Out of Scope

- `sync-installed.mjs` and the pack layout.

## Deferred

Nothing deferred.
