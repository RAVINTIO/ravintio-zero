---
title: "Requirement: REQ-005 - Advisory reply check"
summary: "A Stop hook flags replies that drift from the writing standard and never blocks."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Advisory reply check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000390-prose-checks
**Source:** US-005
**Priority:** should-have

## User Story

As a developer, I get a short note when a reply drifts from the standard, so that I can see the drift without a block.

## Functional Requirements
- `hooks/enforcement/check-reply-writing.mjs` checks the last reply for `sentence-length` and `blocklist` breaches.
- The note quotes the first 40 characters of each offending sentence and names the rule. It shows at most 3 sentences.
- The hook runs only when `.claude/output-styles/ravintio-writing.md` exists, so a developer who skips the writing style gets no note.
- The hook exits 0 for every input, including bad JSON and a missing payload field.
- `setup.sh` and `setup.ps1` register the hook as an advisory Stop hook with the same command, and the install lifecycle list names it.

## Acceptance Criteria
- [ ] AC-1: long sentence produces a note
  - Given a reply with a 30-word sentence and the output style file present
  - When the hook runs
  - Then it prints a `systemMessage` that quotes the first words of the sentence
- [ ] AC-2: always exits 0
  - Given bad JSON, an empty payload, and a clean reply
  - When the hook runs on each
  - Then every run exits 0 and the clean reply prints nothing
- [ ] AC-3: both setup scripts register it
  - Given a fresh install by `setup.sh` and by `setup.ps1`
  - When a test reads `.claude/settings.json`
  - Then the Stop event holds the hook with the same command, and a rerun adds no duplicate

## Dependencies
- REQ-001 for the shared rules module.
