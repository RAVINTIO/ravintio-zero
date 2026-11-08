---
title: "Domain Glossary - Ship postmortems"
summary: "Terms used by the postmortem check and the queue wait."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Ship postmortems

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000392-ship-postmortems
**Version:** 0.60.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| CAPA | Corrective, preventive, and detective actions. A postmortem holds one row of each. | none | ravintio-zero |
| Corrective action | An action that fixes this failure. | none | ravintio-zero |
| Preventive action | An action that stops the same kind of failure. | none | ravintio-zero |
| Detective action | An action that finds the failure sooner next time. | none | ravintio-zero |
| Postmortem line | A build-log line `Postmortem: {path} ({timestamp})`. A line that names a `REQ-nnn` covers that requirement. | none | ravintio-zero |
| Check bucket | The `bucket` field of `gh pr checks --json`. Its values are `pass`, `fail`, `pending`, `skipping`, and `cancel`. | none | ravintio-zero |
