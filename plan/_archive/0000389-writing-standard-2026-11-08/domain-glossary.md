---
title: "Domain Glossary - Writing standard"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Writing standard

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Version:** 0.61.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Writing standard | The pack's prose rules, in `standards/writing-standards.md` | style guide | ravintio-zero |
| Output style | A Claude Code Markdown file in `.claude/output-styles/` that changes how the main session responds | style | ravintio-zero |
| Style rules region | The part of the standard between the `style-rules` markers. It becomes the body of the output style. | none | ravintio-zero |
| Summary region | The short part of the standard between the `summary` markers. It becomes the Codex section. | none | ravintio-zero |
| Generator | `scripts/writing-style.mjs`, which prints each tool's output from the regions | none | ravintio-zero |
