---
title: "Domain Glossary - Guard gaps closed"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Guard gaps closed

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000357-guard-gaps-closed
**Version:** 0.54.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Guard | A PreToolUse hook that blocks a call with exit 2. | | ravintio-zero |
| Launcher | `guard-run.mjs`. It runs a hook script and turns a failure into exit 2 in guard mode. | | ravintio-zero |
| Fail closed | A guard that cannot run blocks the call. | | ravintio-zero |
| Advisory hook | A hook that never blocks. A failure exits 0. | | ravintio-zero |
| Segment | One part of a Bash command, split on `&&`, `\|\|`, `;`, `&`, `\|`, and newlines. | | ravintio-zero |
| Forced add | A `git add` or `git stage` that puts an ignored file into the index. | | ravintio-zero |
