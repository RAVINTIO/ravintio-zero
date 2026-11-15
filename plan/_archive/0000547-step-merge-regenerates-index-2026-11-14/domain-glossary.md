---
title: "Domain Glossary - Step base merge regenerates the backlog index"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Step base merge regenerates the backlog index

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000547-step-merge-regenerates-index
**Version:** 0.115.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Manual base merge | A step session merges `origin/initiative/{id}-{slug}` into its feature branch by hand, because the PR conflicts. | none | ravintio-zero |
| Stale index | A `plan/backlog/index.md` that differs from the output of `backlog-index.mjs`. | none | ravintio-zero |
