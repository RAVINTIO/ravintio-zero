---
title: "Domain Glossary - Install lifecycle"
summary: "Terms used by the install lifecycle change."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Install lifecycle

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Version:** 0.61.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Doctor | The `--doctor` check that reports whether an install is healthy. | none | ravintio-zero |
| Update | The `--update {source}` command that copies a newer pack, commits it, and reruns setup. | none | ravintio-zero |
| Uninstall | The `--uninstall` command that reverses setup's changes. | none | ravintio-zero |
| Clean-tree check | The test that `ravintio-zero/` and `ravintio-overrides/` hold no uncommitted file. | none | ravintio-zero |
| Setup record | `plan/state/{tool}.md`, the tracked file that holds the active setup flags. | none | ravintio-zero |
| Pack facts file | `ravintio-zero/pack-facts.json`, generated from the pack's own sources. | none | ravintio-zero |
