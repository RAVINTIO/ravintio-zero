---
title: "Domain Glossary - Reply times match the clock"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Reply times match the clock

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000499-reply-times-match-clock
**Version:** 0.101.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Clock read | The value of the local clock at the moment an agent writes a time. It comes from `date +%H:%M` or from the clock hook. | | ravintio-zero |
| Clock hook | The `PostToolUse` hook `clock-context.mjs`. It returns the local `hh:mm` after each tool call. | | ravintio-zero |
| Activity line | A watcher line that starts `I-C Run: activity:` and describes one tool call or message of a step. | | ravintio-zero |
| Margin | The most minutes a reply time may differ from the clock before the reply hook warns. | | ravintio-zero |
