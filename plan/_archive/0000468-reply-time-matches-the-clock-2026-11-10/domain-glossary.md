---
title: "Domain Glossary - Reply time matches the clock"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Reply time matches the clock

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000468-reply-time-matches-the-clock
**Version:** 0.83.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Reply time | The `hh:mm` that leads a reply in an active run | leading time | ravintio-zero |
| Margin | The most minutes a reply time may differ from the clock before the hook warns. It is 5 | tolerance | ravintio-zero |
| Prefix miss | A final reply with no valid prefix, or a time beyond the margin. The hook logs it to `plan/.prefix-misses.log` | miss | ravintio-zero |
