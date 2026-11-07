---
title: "Domain Glossary - Safe parallel commits"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Safe parallel commits

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000359-safe-parallel-commits
**Version:** 0.56.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Tree-wide git command | A git command that changes every file in the working tree or the index, such as `git stash`, `git reset`, or `git clean`. | | ravintio-zero |
| Scratch clone | A temporary clone in a scratch folder, used to test a clean tree without touching the shared tree. | | ravintio-zero |
| Path-limited commit | A commit made with `git commit -m "{message}" -- {paths}`, so it holds only those paths. | | ravintio-zero |
