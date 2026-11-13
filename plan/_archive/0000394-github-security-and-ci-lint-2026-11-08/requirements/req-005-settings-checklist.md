---
title: "Requirement: req-005 - Settings checklist"
summary: "The step hands the admin-only settings to the human and checks them with gh api."
status: "active"
version: "0.1.0"
---
# Requirement: req-005 - Settings checklist

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000394-github-security-and-ci-lint
**Source:** US-005
**Priority:** must-have

## User Story

As the repo admin, I get one settings checklist and a `gh api` check, so that no setting stays off unseen.

## Functional Requirements

- `node ravintio-zero/scripts/github-settings.mjs list` prints the checklist: secret scanning, push protection, Dependabot security updates, private vulnerability reporting, topics, and the `workflow-lint` required check.
- `node ravintio-zero/scripts/github-settings.mjs check` reads each setting through `gh api`, prints `on` or `off` per item, and exits 1 if any item is off.
- The step prints the checklist at P3 and stops with `Question:`. After the human acts, the resumed session runs `check`.

## Acceptance Criteria

- [ ] AC-1: Checklist lists every item
  - Given the script
  - When `list` runs
  - Then the output names all six items
- [ ] AC-2: Check reports state
  - Given a stub `gh` that returns every setting on, then one off
  - When `check` runs against each
  - Then the first run exits 0 and the second exits 1 and names the item

## Dependencies

- req-003 (the required check names the `workflow-lint` job)
