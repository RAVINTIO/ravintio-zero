---
title: "Domain Glossary - Step sessions meet pending migrations"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Step sessions meet pending migrations

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000560-step-sessions-and-pending-migrations
**Version:** 0.141.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Ledger | The table in `plan/state/migrations.md` with one row per migration and its result. | | ravintio-zero |
| Detect line | The `**Detect:**` line of a migration. It lists checks that say whether the migration applies. | Detect | ravintio-zero |
| Pending line | The `pending migration: {id}` line that `resume-detect.mjs` prints. | | ravintio-zero |
