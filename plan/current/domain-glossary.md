---
title: "Domain Glossary - 0000548-ack-write-mid-suite-fails-run"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.115.0"
---
# Domain Glossary - 0000548-ack-write-mid-suite-fails-run

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000548-ack-write-mid-suite-fails-run
**Version:** 0.115.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Suite marker | The git-ignored file `plan/.suite-running` that holds the pid of a live runner | marker | ravintio-zero |
| Ack | The session id in `plan/.orchestrator-ack` that the strict hook compares with the prompt | none | ravintio-zero |
| Tree check | The runner comparison of tracked and untracked files before and after the suites | none | ravintio-zero |
