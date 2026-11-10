---
title: "Domain Glossary - Driver reads blocks from the reply"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Driver reads blocks from the reply

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000440-driver-reads-reply-blocks
**Version:** 0.78.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Reply | The `result` text of the last `result` event in a session's stream-json output. | final reply | driver |
| Block | A `Blocked:` or `Question:` line with no later `Resolved:` line. | stop line | driver |
