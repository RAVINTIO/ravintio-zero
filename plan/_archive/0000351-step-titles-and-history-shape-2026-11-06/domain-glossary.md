---
title: "Domain Glossary - Step titles and history shape"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Step titles and history shape

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000351-step-titles-and-history-shape
**Version:** 0.49.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Step commit | The squash commit that one initiative step leaves on the initiative branch. | step squash | ravintio-zero |
| Chore commit | The one commit after the step commits, which holds admin work that aligns with no step. | admin commit | ravintio-zero |
| Title column | The `Title` column of the `## Steps` table. It holds the feature title in sentence case. | none | ravintio-zero |
| Shape | The order and count of first-parent commits: N step commits, then at most one chore commit. | none | ravintio-zero |
