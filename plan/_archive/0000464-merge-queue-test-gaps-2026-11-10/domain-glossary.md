---
title: "Domain Glossary - Merge queue test gaps"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Merge queue test gaps

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000464-merge-queue-test-gaps
**Version:** 0.84.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Rerun | A second `run` on a PR whose branch already holds the version and chart edits | none | ravintio-zero |
| Post-set check | The `cmdVersions` call after `setVersions`, which stops the run if the files differ | none | ravintio-zero |
| Dash guard | The check that refuses a ref name that starts with a dash | none | ravintio-zero |
