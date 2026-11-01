---
title: "Requirement: REQ-001 - Check script"
summary: "A script fails a PR into main that breaks the branch or commit rule."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Check script

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000327-squash-before-main
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I want CI to fail a PR that breaks the rule, so that the rule holds when the agent forgets.

## Functional Requirements
- `ravintio-zero/scripts/check-pr-into-main.mjs` takes `--head-ref {name}`, `--base {ref}`, `--head {ref}`, and an optional `--root {dir}`.
- A head ref that starts `initiative/` exits 0 with no git call.
- A head ref that starts `chore/` or `hotfix/` exits 0 when `{base}..{head}` holds exactly one commit. Zero or more than one exits 1.
- Any other head ref exits 1, including every `feat/*` ref.
- A missing flag or a git error exits 2.
- The script prints the head ref and the count, never commit bodies.

## Acceptance Criteria
- [ ] AC-1: chore and hotfix commit count
  - Given a fixture repo with a `chore/x` branch of one commit and another of two
  - When the script runs for each
  - Then the one-commit branch exits 0 and the two-commit branch exits 1
  - And the same holds for `hotfix/x`
- [ ] AC-2: other prefixes
  - Given head refs `feat/x` and `initiative/y`
  - When the script runs for each
  - Then `feat/x` exits 1 and `initiative/y` exits 0 whatever its commit count
- [ ] AC-3: usage and git errors
  - Given a missing `--head-ref` flag or an unknown base ref
  - When the script runs
  - Then it exits 2

## Dependencies
none
