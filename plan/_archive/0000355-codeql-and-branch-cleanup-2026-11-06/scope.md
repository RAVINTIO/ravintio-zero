---
title: "Scope - CodeQL and branch cleanup in CI"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - CodeQL and branch cleanup in CI

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000355-codeql-and-branch-cleanup
**Version:** 0.53.0

## In Scope

- `.github/workflows/codeql.yml` for JavaScript and GitHub Actions, on PRs into `main` and `initiative/**`.
- A `cleanup-branch` job in `ravintio-zero/hooks/ravintio.yml` and `.github/workflows/ravintio.yml`, on `pull_request` `closed`, with `contents: write` on that job only.
- A guard on every existing pull request job that skips the `closed` event.
- A marker comment that `test-0000169-req-006` reads in place of its fixed job name list.
- A workflow cause in the plan skill's test impact scan.
- Incomplete escaping in the injection points item of the P3 security checklist.
- An edit to entry 0000323: CodeQL runs from the workflow, and the branch deletion item goes.

## Out of Scope

- Turning off CodeQL default setup in repo settings. A human does it.
- The other items in entry 0000323.
- Any change to a hook.
- Installing the cleanup job into a consumer repo that already holds `ravintio.yml`. Setup keeps an existing file.

## Deferred

Nothing deferred.
