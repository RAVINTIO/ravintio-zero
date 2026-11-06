---
title: "Domain Glossary - Reshape at delivery"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Reshape at delivery

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Version:** 0.51.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Reshape | Rebuild an initiative branch as one titled commit per step, then one chore commit, on a new branch. | none | ravintio-zero |
| Reshaped branch | The new branch `{branch}-reshaped`. The coordinator raises the initiative PR from it. | none | ravintio-zero |
| Step tag | The tag `v{Version}` at a step squash. The chart `Version` column names it. | version tag | ravintio-zero |
| Aligned admin commit | An admin commit that the coordinator assigns to a step with `--assign`. It folds into that step's new commit. | none | ravintio-zero |
| Chore commit | The last commit. Its tree equals the old head tree. It holds admin that aligns with no step. | admin commit | ravintio-zero |
| Replay | Apply a commit's change onto a new tip with a three-way merge. | none | ravintio-zero |
