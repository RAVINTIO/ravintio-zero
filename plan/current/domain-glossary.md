---
title: "Domain Glossary - 0000583-step-temp-cleanup-after-merge"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - 0000583-step-temp-cleanup-after-merge

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Version:** 0.146.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| private temp folder | The folder `{worktree}/.t` that the driver sets as `TMPDIR` for one step session | step scratch | ravintio-zero |
| sandbox | The Claude Code sandbox that the driver turns on for a step session with `--settings` | none | ravintio-zero |
| leaked entry | A `ravintio_*` or `ravintio-gitconfig*` entry that a suite left in the user temp folder | none | ravintio-zero |
