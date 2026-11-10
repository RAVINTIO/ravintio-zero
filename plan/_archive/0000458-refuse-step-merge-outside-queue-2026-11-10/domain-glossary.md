---
title: "Domain Glossary - refuse a step merge outside the queue"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - refuse a step merge outside the queue

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000458-refuse-step-merge-outside-queue
**Version:** 0.80.1

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Step session | A `claude` session that the concurrent driver starts for one initiative step. It sees `RAVINTIO_INITIATIVE_QUEUE=1` | none | ravintio-zero |
| Merge queue | `merge-queue.mjs run`, which sets the version and squash-merges one ready step PR | queue | ravintio-zero |
