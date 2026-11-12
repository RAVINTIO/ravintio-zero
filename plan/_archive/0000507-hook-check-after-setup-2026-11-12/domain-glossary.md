---
title: "Domain Glossary - Check every hook after setup"
summary: "Definitions of domain terms used within this feature."
status: "draft"
version: "0.1.0"
---
# Domain Glossary - Check every hook after setup

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000507-hook-check-after-setup
**Version:** 0.110.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Hook | A command in `.claude/settings.json` that Claude Code runs on an event | none | ravintio-zero |
| Matcher | The pattern in a hook entry that selects the tool or prompt it applies to | none | ravintio-zero |
| Guard | A hook that blocks a tool call with exit 2 | fail-closed hook | ravintio-zero |
| Sample input | One fixed JSON document the check feeds to a hook for its event and matcher | none | ravintio-zero |
| Hook check | The script `hook-check.mjs`, which runs every hook with a sample and judges the result | none | ravintio-zero |
| Deliberate block | Exit 2 from a guard on its sample, which the check counts as a pass | none | ravintio-zero |
