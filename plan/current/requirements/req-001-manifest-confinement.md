---
title: "Requirement: req-001 - Manifest confinement"
summary: "Setup removes only folders inside its skills directory."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - Manifest confinement

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000381-setup-safety
**Source:** US-001
**Priority:** must-have

## User Story

As a developer, I re-run setup, so that it removes only skill folders inside my tool's skills directory.

## Functional Requirements

- Setup writes each `.ravintio-manifest` path relative to the repo root.
- Setup resolves each manifest line under the repo root. A legacy absolute line stays valid only if it resolves inside the skills directory.
- Setup skips a line that contains `..`, resolves outside `$PROJECT_ROOT/$TOOL_SKILLS_DIR`, is not a direct child, or is a symlink. It prints a warning for each skipped line.
- The test runner lists `.claude/skills/` before the first suite and after the last, and fails on a difference.
- `setup.sh` and `setup.ps1` behave the same.

## Acceptance Criteria

- [ ] AC-1: Outside lines skipped
  - Given a manifest with an absolute path, a `..` path, and a symlink that point outside the skills directory
  - When setup re-runs
  - Then every target survives and setup prints a warning for each line
- [ ] AC-2: Relative manifest written
  - Given a fresh install
  - When setup finishes
  - Then each manifest line is relative and starts with the tool skills directory
- [ ] AC-3: Suites leave skills alone
  - Given the full test run
  - When it ends
  - Then the listing of `.claude/skills/` equals the listing before the run

## Dependencies

- None
