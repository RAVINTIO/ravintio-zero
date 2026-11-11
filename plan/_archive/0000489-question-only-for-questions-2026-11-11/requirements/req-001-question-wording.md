---
title: "Requirement: REQ-001 - Question asks the human something"
summary: "The orchestrator text and the standards say that Question asks the human something and that a step waiting on its own work keeps working."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Question asks the human something

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000489-question-only-for-questions
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I use `Question:` only to ask the human something, so that the driver stops only for a real question.

## Functional Requirements
- `roadmap-standards.md` gains rule `icrun-question-real` in I-C Run. A `Question:` line asks the human a question and ends with a question mark. A step that waits for its suites, CI, or a background task keeps working.
- The rule says a step session cannot schedule a wakeup. It waits in the foreground or as a background task.
- `pipeline-reference.md` and `SKILL.md` describe `Question:` as a line that asks the human something. The `SKILL.md` change adds 48 bytes or fewer.
- The `SKILL.md` Question line keeps the words `exception stop`, and the "never end your turn" line stays.

## Acceptance Criteria
- [ ] AC-1: the standards state the rule
  - Given the file `roadmap-standards.md`
  - When a reader looks for `icrun-question-real`
  - Then the rule says `Question:` asks the human and that a waiting step keeps working
- [ ] AC-2: the status text says Question asks the human
  - Given `SKILL.md` and `pipeline-reference.md`
  - When a reader reads the Question line
  - Then it says the line asks the human a question
- [ ] AC-3: the caps hold
  - Given the edited `SKILL.md`
  - When the size tests run
  - Then the orchestrator is 9,000 bytes or fewer and all skills total 1,720 lines or fewer

## Dependencies
- None.
