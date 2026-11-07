---
title: "Domain Glossary - CodeQL and branch cleanup in CI"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - CodeQL and branch cleanup in CI

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000355-codeql-and-branch-cleanup
**Version:** 0.53.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Default setup | The GitHub repo setting that runs CodeQL with no workflow file. It scans PRs into the default branch only. | | ravintio-zero |
| Advanced setup | A CodeQL workflow file in `.github/workflows/`. It sets its own branches and languages. | | ravintio-zero |
| Cleanup job | The `cleanup-branch` job that deletes a merged PR's head branch. | | ravintio-zero |
| Marker comment | The line `# ravintio:job-guard-exempt` above a job key. The shape test skips the pull request guard check for that job. | | ravintio-zero |
| Head branch | The branch a PR merges from. | | ravintio-zero |
| Guard | The `if` condition that stops a job on an event it should not run on. | | ravintio-zero |
