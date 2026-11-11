---
title: "Requirement: REQ-002 - Reply hook flags I and you"
summary: "The advisory reply check flags I and you in a reply that opens with a run prefix."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Reply hook flags I and you

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000521-replies-name-actors-by-role
**Source:** US-002
**Priority:** must-have

## User Story

As the human, I see an advisory note when a run reply uses "I" or "you", so that the habit stops.

## Functional Requirements
- `check-reply-writing.mjs` adds the rule `actor-pronoun`. It flags "I", "you", and "your" as whole words.
- The rule runs only on a run reply. Its first line starts with `hh:mm` and a run prefix. The prefixes are `P0` to `P4`, `I-A` to `I-E`, and `Supervise:`.
- The rule skips code and lines that start with `>`. A prefix such as `I-C` never counts as "I".
- The note stays advisory. The hook exits 0 on every input.

## Acceptance Criteria
- [ ] AC-1: a run reply with I or you gets a note
  - Given a reply that opens with `18:00 I-C Run: Complete:` and holds "I fixed it"
  - When the hook runs
  - Then the output names the rule `actor-pronoun` and the hook exits 0
- [ ] AC-2: other replies get no note
  - Given a reply with "you" and no run prefix, or a run reply that names actors by role
  - When the hook runs
  - Then the output is empty
- [ ] AC-3: the prefix and code do not count
  - Given a run reply whose only "I" sits in `I-C`, in inline code, or in a `>` line
  - When the hook runs
  - Then the output is empty

## Dependencies
- None.
