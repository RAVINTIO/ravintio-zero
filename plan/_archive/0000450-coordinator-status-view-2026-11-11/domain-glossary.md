---
title: "Domain Glossary - Coordinator status view"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Coordinator status view

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000450-coordinator-status-view
**Version:** 0.95.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Live stop | An open `Blocked:` or `Question:` line, or a queue stop line, for a step that the chart does not mark merged. | open stop | ravintio-zero |
| Status view | The `I-C Run: status:` lines that `initiative-status.mjs` prints. | | ravintio-zero |
| Coordinator | The human's session that runs the initiative skill. | | ravintio-zero |
| Control file | A `running` or `ready` file in `plan/.initiative-control/step-{n}/`. | | ravintio-zero |
