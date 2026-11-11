---
title: "Domain Glossary - Driver favours the critical path"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Driver favours the critical path

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000491-driver-favours-critical-path
**Version:** 0.101.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Chain | The longest run of unmerged steps that starts at a step and follows its dependants. | | ravintio-zero |
| Chain length | The number of steps in the chain, counting the step itself. | | ravintio-zero |
| Dependant | A step that lists another step in `After`, or a later step in the same lane. | | ravintio-zero |
| Startable step | A pending step whose `After` steps have merged and whose lane is free. | | ravintio-zero |
