---
title: "Domain Glossary - Setup safety"
summary: "Terms used by the setup safety change."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Setup safety

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000381-setup-safety
**Version:** 0.60.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Skills directory | `$PROJECT_ROOT/$TOOL_SKILLS_DIR`, the only place setup may remove a skill folder from. | none | ravintio-zero |
| Manifest | `.ravintio-manifest`, a file that lists the folders or files a setup run installed. | none | ravintio-zero |
| Confinement check | The test that a manifest line resolves to a direct child of the skills directory. | none | ravintio-zero |
| Capability skill | A developer skill kept in `ravintio-overrides/capability-skills/`. | none | ravintio-zero |
| Retired command | A command file an earlier pack release shipped in `.claude/commands/`, which the pack no longer ships. | none | ravintio-zero |
