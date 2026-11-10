---
title: "Domain Glossary - ready file helper"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - ready file helper

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000442-ready-file-helper
**Version:** 0.81.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| ready file | The file `ready` in the step's control folder. It holds the PR number of a step that has reached the merge queue. | ready | ravintio-zero |
| control folder | `plan/.initiative-control/step-{n}/`, named by `RAVINTIO_INITIATIVE_CONTROL`. The driver owns it. | none | ravintio-zero |
| recovery | The driver step that reads the PR number from the step branch when the ready file is bad. | none | ravintio-zero |
