---
title: "Stack allowlist"
summary: "The sample list of languages, frameworks, and data stores that design.md may name."
status: "active"
version: "0.1.0"
---
# Stack allowlist

The P3 gate `stack-allowlist` reads the `allow` array in `archetype.json`. Each stack entry in `plan/current/design.md` must appear in that array. Keep this list and the array identical. Edit both after you install the archetype.

## Allowed stack

- TypeScript
- Node.js
- React
- PostgreSQL
- Redis
- Docker
- GitHub Actions

## How to change the list

1. Add one bullet for each language, framework, or data store you allow.
2. Remove the sample entries you don't use.
3. Update the `allow` array to match.
4. Run `scripts/archetype-gates.mjs` to check `design.md` against the list.
