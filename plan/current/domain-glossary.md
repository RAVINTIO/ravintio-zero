---
title: "Domain Glossary - driver setup stop"
summary: "Terms used by the driver setup stop."
status: "active"
version: "0.41.0"
---
# Domain Glossary - driver setup stop

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000313-driver-setup-stop
**Version:** 0.41.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Setup stop | A planned driver exit after a merged step that changes an installed pack file. The stop line starts `I-D Advance: Setup:`. | `Setup:` line | ravintio-zero |
| Restart stop | A driver exit after a merged step that changes the driver, the watcher, or the initiative skill. | `Restart:` line | ravintio-zero |
| Setup path | A path that setup installs: `ravintio-zero/skills/`, `ravintio-zero/hooks/`, `ravintio-zero/setup.sh`, `ravintio-zero/setup/`. | watched setup file | ravintio-zero |
| Combined line | One stop line that starts `I-D Advance: Restart: Setup:`. | none | ravintio-zero |
