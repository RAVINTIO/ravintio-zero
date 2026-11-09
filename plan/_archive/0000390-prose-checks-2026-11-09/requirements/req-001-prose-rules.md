---
title: "Requirement: REQ-001 - Prose rules and linter"
summary: "A script checks Markdown and commit messages against the writing standard."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Prose rules and linter

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000390-prose-checks
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I see a script check Markdown and commit messages against the writing standard, so that new breaches fail the check.

## Functional Requirements
- `hooks/enforcement/prose-rules.mjs` exports a function that takes text and returns breaches with a line, a rule id, and a detail.
- The rules are `sentence-length` (over 25 words), `blocklist`, `semicolon`, `em-dash`, and `passive`.
- The extractor skips front matter, fenced code, inline code, tables, and HTML comments.
- `scripts/prose-check.mjs check` prints `file:line rule: detail` for each breach and exits 1 on a failure.
- `check --message <file>` reads a commit message. It skips comment lines and the trailer lines after the subject.

## Acceptance Criteria
- [ ] AC-1: long sentence fails
  - Given a Markdown file in `docs/` with a 26-word sentence
  - When `prose-check.mjs check --files` runs on it
  - Then the script exits 1 and prints the file, the line, and `sentence-length`
- [ ] AC-2: code lines pass
  - Given a 40-word sentence inside a fenced code block, inline code, and a table row
  - When the script checks the file
  - Then it reports no breach
- [ ] AC-3: other rules fire
  - Given a file that holds a semicolon, an em dash, a blocklist word, and a passive phrase
  - When the script checks the file
  - Then it reports `semicolon`, `em-dash`, `blocklist`, and `passive`

## Dependencies
- `ravintio-zero/standards/writing-standards.md` from step 13.
