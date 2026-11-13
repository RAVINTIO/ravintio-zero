---
title: "Domain Glossary - Driver clears ready files of merged steps"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.110.0"
---
# Domain Glossary - Driver clears ready files of merged steps

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000509-clear-merged-ready-files
**Version:** 0.110.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Driver | The script `initiative-run.mjs` that starts step sessions and runs the merge queue | runner | ravintio-zero |
| Control folder | The folder `plan/.initiative-control/step-{n}/` that holds the `running`, `ready`, and `stopped` files of one step | none | ravintio-zero |
| Ready file | The file `ready` in a control folder. It holds the number of the step's PR. | none | ravintio-zero |
| Merged step | A chart row with status `merged` | none | ravintio-zero |
| Clearing pass | The pass at driver start that removes the ready files of merged steps | none | ravintio-zero |
| Cleared line | The line `I-C Run: Cleared:` that names a ready file the pass removed | none | ravintio-zero |
| Kept line | The line `I-C Run: Kept:` that names a file the pass left in place and why | none | ravintio-zero |
