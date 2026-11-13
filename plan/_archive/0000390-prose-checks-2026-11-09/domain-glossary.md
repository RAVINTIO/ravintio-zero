---
title: "Domain Glossary - Prose checks"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Prose checks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000390-prose-checks
**Version:** 0.71.0

> The ubiquitous language for this feature. If the glossary says "Breach", the code says `breach`.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Breach | One place where text breaks a rule of the writing standard. It has a file, a line, and a rule id | violation | ravintio-zero |
| Rule id | The name of a check: `sentence-length`, `blocklist`, `semicolon`, `em-dash`, or `passive` | check name | ravintio-zero |
| Baseline | The recorded breach count for each file and rule, in `plan/state/prose-baseline.json` | ratchet file | ravintio-zero |
| Ratchet | The rule that a count may fall but never rise | none | ravintio-zero |
| Prose scope | The Markdown paths the linter reads. Archived records are outside it | scan scope | ravintio-zero |
| Edit pass | The P3 loop where a fresh subagent fixes breaches in changed user-facing docs | docs review | ravintio-zero |
| Advisory hook | A Stop hook that reports a note and always exits 0 | none | ravintio-zero |
