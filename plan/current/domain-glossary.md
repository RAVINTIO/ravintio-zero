---
title: "Domain Glossary - Pending migrations reach the human early"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Pending migrations reach the human early

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000536-pending-migrations-reach-the-human-early
**Version:** 0.113.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Pending migration | A migration file in `ravintio-zero/migrations/` that `resume-detect.mjs` reports with a `pending migration:` line. | none | ravintio-zero |
| Migration row | A `## Decisions` row whose Fork starts with `Migration:` and whose answer is `all` or `none`. | none | ravintio-zero |
| Migration pending line | A build-log line, `Migration pending: {id}`, that a step writes for a migration with no row. | none | ravintio-zero |
