---
title: "Domain Glossary - unit dispatch"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - unit dispatch

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000386-unit-dispatch
**Version:** 0.70.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Unit | One piece of dispatched work, such as a TDD subagent in P2. | none | ravintio-zero |
| Unit class | One of `content`, `code`, `test`, or `config`. It sets the base tier and effort. | task class | agent-dispatch-standards.md |
| Inline unit | A `content` unit that applies agreed text or changes one file. It runs the TDD loop in the main session with no subagent. | none | ravintio-implement |
| Score | The count of signals a unit meets, from 0 to 3. | none | agent-dispatch-standards.md |
| Tier | `cheaper` or `primary`, resolved to a model name per host tool. An inline unit logs `inline`. | model tier | agent-dispatch-standards.md |
| Effort | `low`, `medium`, or `high`. An inline unit logs `none`. | none | agent-dispatch-standards.md |
