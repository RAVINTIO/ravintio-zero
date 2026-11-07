---
title: "Domain Glossary - Steps run to the end"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Steps run to the end

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Resume | Continue a step session with `claude -p --resume {session}` after it exits 0 unmerged. | none | ravintio-zero |
| Unmerged exit | A step session that exits 0 while the chart position is unchanged and no block exists. | early end | ravintio-zero |
| Session id | The `session_id` field in the stream events of a step log. | none | ravintio-zero |
| Setup record | The tracked file `plan/state/{tool}.md` that holds the tool, flags, and `writtenAt`. | none | ravintio-zero |
| Step CI fixes | The chart field `allowed` or `stop` that says whether a step fixes its own CI failure. | none | ravintio-zero |
