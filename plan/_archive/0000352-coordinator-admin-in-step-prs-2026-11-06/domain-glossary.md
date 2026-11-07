---
title: "Domain Glossary - Coordinator admin in step PRs"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Coordinator admin in step PRs

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000352-coordinator-admin-in-step-prs
**Version:** 0.50.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Admin work | A change to plan or pack files that serves the run and not the feature itself. | none | ravintio-zero |
| Aligned admin | Admin work that step N caused or that serves step N. It ships in step N's PR. | none | ravintio-zero |
| Unaligned admin | Admin work that fits no step. It lands through a `chore/` PR, or in the one chore commit at delivery. | none | ravintio-zero |
| Queue item | A folder in `plan/.initiative-queue/`. Its `item.md` names the step and the destination path. | none | ravintio-zero |
| Coordinator | The initiative session that charts, activates, and delivers. It never runs a step. | initiative session | ravintio-zero |
