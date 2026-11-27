---
title: "Domain Glossary - Plan lists the change shapes a diff reader must handle"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Plan lists the change shapes a diff reader must handle

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000577-plan-lists-change-shapes
**Version:** 0.137.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Test impact scan | The plan step that greps the tests for each cause a run triggers. | scan | ravintio-zero |
| Change shape | The kind of change a git diff reports for a file: add, rename, or delete. | | ravintio-zero |
| Test world | A fixture repo or file set that a suite builds to exercise one case. | world | ravintio-zero |
