---
title: "Domain Glossary - Refuse a symlink at the writing style output paths"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Refuse a symlink at the writing style output paths

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000551-refuse-symlink-style-outputs
**Version:** 0.137.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Style file | `.claude/output-styles/ravintio-writing.md`, the Claude Code output style that setup writes. | output style | ravintio-zero |
| Writing block | The text between `<!-- ravintio-writing:start -->` and `<!-- ravintio-writing:end -->` in `AGENTS.md`. | writing section | ravintio-zero |
| Link | A symlink on Unix, or a symlink or junction on Windows. A broken link counts. | symlink | ravintio-zero |
