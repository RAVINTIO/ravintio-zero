---
title: "Domain Glossary - Pack source in src"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Pack source in src

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000397-pack-source-in-src
**Version:** 0.76.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Pack source | The folder `src/ravintio-zero/`. Maintainers edit it. | source | ravintio-zero |
| Installed copy | The folder `ravintio-zero/`, a plain copy of the source. Hooks, the driver, and skills run it. | installed pack | ravintio-zero |
| Parity | The two folders match byte for byte. | none | ravintio-zero |
| Refresh | Copy the source over the installed copy with `sync-installed.mjs`. | sync | ravintio-zero |
