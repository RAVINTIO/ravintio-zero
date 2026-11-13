---
title: "Domain Glossary - Driver prints a stop summary"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.111.0"
---
# Domain Glossary - Driver prints a stop summary

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000511-driver-stop-summary
**Version:** 0.111.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Driver | The script `initiative-run.mjs` that starts step sessions and runs the merge queue | runner | ravintio-zero |
| Summary block | The `I-C Run: Summary:` lines that the driver prints just before its final line | stop summary | ravintio-zero |
| Driver fix | A repair the driver makes by itself, such as clearing a ready file, and names in a line | none | ravintio-zero |
| Action line | The last summary line. It names the one action the human takes, or `none`. | none | ravintio-zero |
| Run record | The merges, fixes, and pending delivery that `out()` notes in memory for one driver process | none | ravintio-zero |
