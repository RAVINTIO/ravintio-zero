---
title: "Domain Glossary - A failed queue run can leave written files in the queue worktree"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - A failed queue run can leave written files in the queue worktree

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000546-queue-failure-leaves-dirty-files
**Version:** 0.126.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Queue worktree | The git worktree where the merge queue runs one PR at a time. | queue tree | ravintio-zero |
| Written files | The chart and the version files that a queue run writes before its set-version commit. | | ravintio-zero |
