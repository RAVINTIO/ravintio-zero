---
title: "Requirement: REQ-001 - CodeQL workflow"
summary: "CodeQL scans PRs into main and initiative branches."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - CodeQL workflow

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000355-codeql-and-branch-cleanup
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I get a CodeQL scan on each PR into `main` or `initiative/**`, so that a finding appears on the step PR.

## Functional Requirements
- `.github/workflows/codeql.yml` triggers on `pull_request` with branches `main` and `initiative/**`.
- The analyse matrix lists `javascript-typescript` and `actions`.
- The workflow grants `security-events: write` and `contents: read` and nothing more.

## Acceptance Criteria
- [ ] AC-1: branches named
  - Given the workflow file
  - When a test parses it
  - Then the pull request branches hold `main` and `initiative/**`
- [ ] AC-2: languages named
  - Given the workflow file
  - When a test reads the matrix
  - Then it lists JavaScript and GitHub Actions
- [ ] AC-3: permissions scoped
  - Given the workflow file
  - When a test reads the permissions
  - Then no `contents: write` appears

## Dependencies
- A human turns off default setup before the merge (CI-checked criterion).
