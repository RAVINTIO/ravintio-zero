---
title: "Domain Glossary - Merge-time versioning"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Merge-time versioning

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000378-merge-time-versioning
**Version:** 0.58.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Merge queue | A script that merges one ready step PR at a time and sets its version at merge. | queue | ravintio-zero |
| Merge order | The order in which step PRs merge. The chart `Version` column records it. | none | ravintio-zero |
| Version file | A file in `version-files.txt` that holds the release version. | none | ravintio-zero |
| Fold | An admin commit that the reshape merges into the next step's commit. | none | ravintio-zero |
| Admin commit | A commit on the initiative branch that is not a step commit. | chore commit | ravintio-zero |
| Chart | `plan/current-initiative/initiative.md`. | initiative file | ravintio-zero |
