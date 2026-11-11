---
title: "Requirement: REQ-002 - Warn on a Question line with no question mark"
summary: "The reply prefix Stop hook warns when a final reply has a Question line with no question mark."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Warn on a Question line with no question mark

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000489-question-only-for-questions
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I see a warning on a `Question:` line with no question mark, so that a false question shows up.

## Functional Requirements
- `check-reply-prefix.mjs` reads the status line after the optional time and a valid prefix. If the status is `Question:` and the line holds no `?`, the hook warns.
- The warning names the "Question check", quotes the first 40 characters of the line, and says the miss does not mean a run stopped.
- The hook appends `{ISO timestamp} question: {first 80 characters}` to `plan/.prefix-misses.log`.
- A `Question:` line with a `?`, and any other status, draws no new warning.
- A reply that already misses the prefix check draws the prefix warning only.
- The hook exits 0 in every case. It blocks nothing and runs no reply text.

## Acceptance Criteria
- [ ] AC-1: a false question warns
  - Given a final reply `I-C Run: Question: step 31 is partway through`
  - When the Stop hook runs
  - Then it prints a warning that names the Question check and logs one line
- [ ] AC-2: a real question passes
  - Given a final reply `I-C Run: Question: Which branch should the step use?`
  - When the Stop hook runs
  - Then it prints nothing and logs nothing
- [ ] AC-3: other statuses pass and the hook exits 0
  - Given final replies with `Blocked:` and `Complete:` statuses and no question mark
  - When the Stop hook runs
  - Then it prints nothing and exits 0

## Dependencies
- REQ-001 for the shared wording.
