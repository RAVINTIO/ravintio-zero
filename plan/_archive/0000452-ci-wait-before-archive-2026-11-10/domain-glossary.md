---
title: "Domain Glossary - 0000452-ci-wait-before-archive"
summary: "Definitions of domain terms used within this feature."
status: "draft"
version: "0.1.0"
---
# Domain Glossary - 0000452-ci-wait-before-archive

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000452-ci-wait-before-archive
**Version:** 0.1.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Archive push | The last push of a step. It holds the archive and the cleared sentinels. | closing push | ravintio-zero |
| Ready | The file `$RAVINTIO_INITIATIVE_CONTROL/ready`. It holds the PR number and hands the PR to the merge queue. | none | ravintio-zero |
| PR head | The commit at the tip of the PR branch. Checks run against it. | head | ravintio-zero |
| Step CI fixes | The chart field that says whether a step may push a fix for a failing check. | none | ravintio-zero |
| Gate-write | The hook that rejects code edits when `plan/current/design.md` is absent. | none | ravintio-zero |
