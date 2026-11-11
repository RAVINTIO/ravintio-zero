---
title: "Feature Brief - Steps use Question only for real questions"
summary: "The instructions say that Question asks the human something, and a Stop hook warns on a Question line with no question mark."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Steps use Question only for real questions

**Feature ID:** 0000489-question-only-for-questions

Source: backlog entry 0000490-question-only-for-questions, filed after the step 22 retrospective.

## Business Goal

On 2026-11-10 step 31 ended its turn with `I-C Run: Question: step 31 is partway through` while it waited for its suites. The driver stops on a `Question:` line, so the line read as a stop that needs the human. The instructions now say that `Question:` asks the human something. A Stop hook warns when a final reply has a `Question:` line with no question mark.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Question wording | As a step session, I use `Question:` only to ask the human something, so that the driver stops only for a real question. | must-have | 1 |
| Question check | As a maintainer, I see a warning when a final reply has a `Question:` line with no question mark, so that a false question shows up. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, and the Stop hook |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/.prefix-misses.log` | ravintio-zero | none |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM), Markdown, Bash |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions |

## Scope Boundaries

### In Scope
- Text in the orchestrator `SKILL.md`, `pipeline-reference.md`, and `roadmap-standards.md`.
- A Question check in `check-reply-prefix.mjs`.
- Tests, an ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

### Out of Scope
- Driver changes. The driver still stops on every open `Question:` line.
- Any hook that blocks a turn.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Hook safety | The hook always exits 0 | Test asserts the exit code |

## Constraints and Assumptions

### Constraints
- The hook warns and never blocks a turn (0000200 ADR-002).

### Assumptions
- The status line is the first non-empty line of the reply. Impact if wrong: the check misses a `Question:` line deeper in the reply.

## Scenario Paths

**Happy path:** A step waits for its suites, keeps working, and ends with `Ready` or `Complete`.

**First-run path:** A step with no earlier reply reads the rule in the orchestrator text.

**Error / sad path:** A reply with `Question:` and no question mark draws a warning and a log line.

**Cross-session continuity:** The hook holds no state. A resumed session reads the same text.

## Acceptance Criteria

- [ ] The orchestrator `SKILL.md`, `pipeline-reference.md`, and `roadmap-standards.md` say that `Question:` asks the human something and that a step waiting on its own work keeps working.
- [ ] The Stop hook warns on a final reply whose `Question:` line holds no question mark.
- [ ] The hook stays silent on a `Question:` line with a question mark, and on any other status.
- [ ] The hook exits 0 in every case.
