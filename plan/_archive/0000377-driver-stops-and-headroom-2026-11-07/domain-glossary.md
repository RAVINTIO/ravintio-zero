---
title: "Domain Glossary - Driver stops and headroom"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Driver stops and headroom

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000377-driver-stops-and-headroom
**Version:** 0.57.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Driver | The script `initiative-run.mjs` that starts each step session in turn. | none | ravintio-zero |
| Watcher | The script `initiative-watch.mjs` that reports step activity. | none | ravintio-zero |
| Open Question | A `Question:` build-log line with no later `Resolved:` line. | open block | ravintio-zero |
| Setup stop | The `I-D Advance: Setup:` stop after a step changes files that setup installs. | none | ravintio-zero |
| Headroom | Bytes left under the 9000 byte cap of the orchestrator `SKILL.md`. | none | ravintio-zero |
