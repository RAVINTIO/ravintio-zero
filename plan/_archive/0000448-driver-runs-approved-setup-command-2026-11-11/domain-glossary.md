---
title: "Domain Glossary - Driver runs the approved setup command"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Driver runs the approved setup command

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000448-driver-runs-approved-setup-command
**Version:** 0.91.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Setup stop | A driver stop that names the pack files a merged step changed and asks for a setup rerun | `Setup:` line | ravintio-zero |
| Confirmation row | A `## Decisions` row whose Fork starts with `Confirmation:`. Its answer holds the exact command the human approved | none | ravintio-zero |
| Approved setup command | The command in the setup `Confirmation:` row, when it matches the allowed form | none | ravintio-zero |
