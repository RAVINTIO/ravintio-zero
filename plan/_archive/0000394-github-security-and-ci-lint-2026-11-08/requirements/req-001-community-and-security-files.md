---
title: "Requirement: req-001 - Community and security files"
summary: "The repo holds the security and community files that GitHub reads."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - Community and security files

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000394-github-security-and-ci-lint
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I find `SECURITY.md`, Dependabot config, templates, and `CODEOWNERS` in the repo, so that reporters and contributors have a route.

## Functional Requirements

- `SECURITY.md` names private vulnerability reporting as the route.
- `.github/dependabot.yml` updates the `github-actions` ecosystem weekly.
- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, issue templates, a PR template, `CODEOWNERS`, and `.github/release.yml` exist.

## Acceptance Criteria

- [ ] AC-1: Files present
  - Given the repo at the step's end
  - When the suite lists the named files
  - Then every file exists and holds text
- [ ] AC-2: Dependabot covers workflows
  - Given `.github/dependabot.yml`
  - When the suite reads it
  - Then it lists the `github-actions` ecosystem

## Dependencies

- None
