---
title: "Domain Glossary - Parallel steps reserve distinct ids"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Parallel steps reserve distinct ids

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000485-adr-number-collision
**Version:** 0.92.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Collision | Two files or folders that two merged steps added under one id. | clash | ravintio-zero |
| Renumber | Give the PR's file the next free id and fix every reference. | | ravintio-zero |
| Counter | The file that holds the next free id, `docs/adr/.next-id` or `plan/backlog/.next-id`. | `.next-id` | ravintio-zero |
| Base merge | The merge of the initiative branch into the PR branch that the queue runs. | | ravintio-zero |
