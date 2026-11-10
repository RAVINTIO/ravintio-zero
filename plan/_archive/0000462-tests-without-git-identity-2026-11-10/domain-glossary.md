---
title: "Domain Glossary - Tests catch runner-only failures"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - Tests catch runner-only failures

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000462-tests-without-git-identity
**Version:** 0.80.1

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Git isolation | A temporary global git config and a cleared environment that the runners give each suite, so a missing identity fails | none | ravintio-zero |
| BOM | The three bytes `EF BB BF` at the start of a UTF-8 file, which Windows PowerShell 5.1 writes | byte order mark | ravintio-zero |
| First-line reader | A script that compares the first line of a boot file with the pack's first line | none | ravintio-zero |
