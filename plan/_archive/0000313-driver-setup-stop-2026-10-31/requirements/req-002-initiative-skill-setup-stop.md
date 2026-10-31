---
title: "Requirement: REQ-002 - initiative skill setup stop"
summary: "The initiative skill treats a Setup: line as a planned stop and reruns setup."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - initiative skill setup stop

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000313-driver-setup-stop
**Source:** US-002
**Priority:** must-have

## User Story

As an initiative owner, I want the initiative skill to treat the `Setup:` line as a planned stop and rerun setup, so that I don't rerun it by hand.

## Functional Requirements

- The `## Stops` section of `ravintio-zero/skills/ravintio-initiative/SKILL.md` names the `Setup:` line as a planned stop, not a failure.
- The skill reads the setup command from the initiative's `Confirmation:` row in `## Decisions`.
- If no row names the command, or the command differs from the row in any way, the skill stops and asks the human.
- After the rerun, the skill checks that every hook in `.claude/settings.json` resolves and runs. If one fails, it stops and reports the hook.
- The skill then starts a new driver and a new watcher.
- A line that names both `Restart:` and `Setup:` gets the setup rerun first, then one new driver.
- The skill stays under 120 lines.

## Acceptance Criteria

- [ ] AC-1: the stop is named
  - Given the initiative skill
  - When a test reads its `## Stops` section
  - Then the section holds `Setup:`, `planned stop`, and `Confirmation:`
- [ ] AC-2: the guards are named
  - Given the same section
  - When a test reads it
  - Then it holds the exact-command rule, the hook check on `.claude/settings.json`, and the new driver and watcher

## Dependencies

- REQ-001 for the stop line
