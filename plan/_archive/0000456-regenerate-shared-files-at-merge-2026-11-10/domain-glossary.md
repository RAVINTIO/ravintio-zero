---
title: "Domain Glossary - Regenerate shared files at merge"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Regenerate shared files at merge

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000456-regenerate-shared-files-at-merge
**Version:** 0.81.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Shared file | A file that most merges edit, such as a counter or an index | none | ravintio-zero |
| Counter file | A `.next-id` file that holds the next id to reserve | none | ravintio-zero |
| Resolver | The `shared-files.mjs` module that fixes shared-file conflicts | none | ravintio-zero |
| Overlap | A file that a step PR and a coordinator PR both change | none | ravintio-zero |
