---
title: "Domain Glossary - Planned restart exits with its own code"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.108.0"
---
# Domain Glossary - Planned restart exits with its own code

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000503-planned-restart-exit-code
**Version:** 0.108.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Driver | The script `initiative-run.mjs` that starts step sessions and runs the merge queue | runner | ravintio-zero |
| Restart stop | A stop after a merged step changed the driver, the watcher, or the initiative skill | restart hit | ravintio-zero |
| Planned stop | A stop that the driver chose and that needs no repair. The driver exits 75. | none | ravintio-zero |
| Failure stop | Any other stop. The driver exits 1. | none | ravintio-zero |
| Handoff | The path where the old driver gives new starts to a successor and exits 0 | none | ravintio-zero |
