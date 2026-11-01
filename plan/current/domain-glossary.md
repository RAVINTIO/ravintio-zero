---
title: "Domain Glossary - initiative history checks"
summary: "Terms used by the history checks."
status: "active"
version: "0.45.0"
---
# Domain Glossary - initiative history checks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000319-initiative-history-checks
**Version:** 0.45.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Titled squash | A commit whose subject reads `{7-digit id}-{slug}: {summary} (#{n})`. | titled commit | ravintio-zero |
| First-parent history | The commits `git log --first-parent` lists from a branch tip back to its base. | none | ravintio-zero |
| Initiative PR | The PR from `initiative/{id}-{slug}` to `main`. The human merges it with a merge commit. | none | ravintio-zero |
| Main merge check | The CI job that fails a push to `main` when an initiative PR landed as a one-parent commit. | none | ravintio-zero |
