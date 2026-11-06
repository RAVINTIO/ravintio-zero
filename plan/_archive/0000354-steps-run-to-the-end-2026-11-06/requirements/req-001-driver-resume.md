---
title: "Requirement: REQ-001 - Driver resumes an unmerged step"
summary: "Driver resumes an unmerged step."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Driver resumes an unmerged step

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I want the driver to resume a step that exits 0 unmerged, up to two times, so that an early end of turn needs no human.

## Functional Requirements
- After `claude` exits 0, with no block and an unchanged position, the driver resumes the session with `claude -p --output-format stream-json --verbose --permission-mode auto --model {model} [--max-turns {n}] --resume {session} "{prompt}"`.
- The driver reads `session_id` from the stream events and checks it against `^[A-Za-z0-9_-]{8,128}$`. It passes the id as one array argument.
- It resumes at most two times and appends to the same step log. It prints `I-C Run: Resuming: step {n} ended its turn unmerged, resume {k} of 2` before each.
- After the second resume, a third unmerged exit prints `I-C Run: Blocked: step {n} exited without merging after 2 resumes` and exits 1.
- A non-zero exit, a block, or a missing or invalid session id never resumes.

## Acceptance Criteria
- [ ] AC-1: resume then merge
  - Given a fake `claude` that exits 0 unmerged on its first run and merges on its resume
  - When the driver runs the step
  - Then the driver runs the fake twice and advances
- [ ] AC-2: cap
  - Given a fake `claude` that always exits 0 unmerged
  - When the driver runs the step
  - Then it resumes two times, prints `Blocked:` on the third exit, and exits 1
- [ ] AC-3: no resume
  - Given a fake `claude` that exits non-zero, or exits 0 with no session id
  - When the driver runs the step
  - Then the driver does not resume and exits 1
