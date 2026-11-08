---
title: "Requirement: req-006 - Briefs name the standard"
summary: "Briefs name the standard."
status: "active"
version: "0.1.0"
---
# Requirement: req-006 - Briefs name the standard

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Source:** US-006
**Priority:** should-have

## User Story

As a maintainer, I see every subagent and step-session brief name the standard, so that output styles reach subagents.

## Functional Requirements

- The Agent Dispatch Template in `agent-dispatch-standards.md` names `ravintio-zero/standards/writing-standards.md` in its skeleton prompts and in its self-contained prompt rule.
- The driver starts each step session with `--append-system-prompt` set to a line that names the standard. The `Run initiative step {n}` prompt stays unchanged.

## Acceptance Criteria

- [ ] AC-1: Dispatch template names the standard
  - Given `agent-dispatch-standards.md`
  - When a test reads the template
  - Then both skeleton prompts and the prompt rule name the standard
- [ ] AC-2: Driver names the standard
  - Given the driver with a stub `claude` binary
  - When it starts a step session
  - Then the stub receives `--append-system-prompt` with the standard path and the unchanged step prompt
