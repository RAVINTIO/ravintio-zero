---
title: "Requirement: REQ-001 - Driver reads blocks from the reply"
summary: "The driver stops on a Blocked or Question line in the step's final reply."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Driver reads blocks from the reply

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000440-driver-reads-reply-blocks
**Source:** US-001, US-002, US-003
**Priority:** must-have

## User Story

- The driver keeps the `result` text of the last `result` stream event of each session. It parses each complete line as JSON. It skips a line that fails.

## Functional Requirements
- The driver keeps the `result` text of the last `result` stream event of each session. It parses each complete line as JSON and skips a line that fails.
- After each session, the driver applies `blockIn` to that text. A hit stops the driver with no resume.
- `blockIn` accepts an optional `hh:mm` time and a short prefix before `Blocked:`, as it does for `Question:`.
- If `plan/current/build-log.md` is missing, the continue prompt names the archived build log of the step, or says no build log exists.
- The roadmap standards describe the reply read.

## Acceptance Criteria
- [ ] AC-1: Reply block stops the driver
  - Given a stub session whose final reply holds `I-D Advance: Blocked: CI failed` and that writes no build log
  - When the driver runs the step
  - Then the driver exits 1, prints `I-C Run: Blocked: step 1 stopped.` with the line, and starts no resume
- [ ] AC-2: Prefixed block in the build log
  - Given a build log that holds `I-D Advance: Blocked: CI failed` with no later `Resolved:` line
  - When the driver reads the build log
  - Then the driver counts the line as a block
- [ ] AC-3: Continue prompt without a log
  - Given a resume while `plan/current/build-log.md` is missing
  - When the driver builds the continue prompt
  - Then the prompt names the archived log, or says none exists, and omits the missing path

## Dependencies
- None.

## Input Validation

- [ ] Input source: the `result` field of a stream-json event in the step's stdout
- [ ] Allowed character pattern: any text is data. The driver never passes it to a shell or builds a path from it.
- [ ] maximum length: 500 characters, the stop line truncates beyond this limit
- [ ] Failure behaviour: a line that fails to parse, or a `result` that is not a string, adds no block
- [ ] Logging policy: the stop line holds the matched line only. The step log stays private.
