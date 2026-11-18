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
| step temp path | A file or folder in a temp folder whose name starts with `step{n}` for step number n, and that is not a prefix of a longer step number | step temp file | ravintio-zero |
| extra worktree | A git worktree of the repo that sits outside `plan/.initiative-worktrees/` and has a step temp path as its folder | none | ravintio-zero |
| leaked entry | A `ravintio_*` or `ravintio-gitconfig*` entry that a suite left in the user temp folder | none | ravintio-zero |
