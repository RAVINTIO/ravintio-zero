---
title: "Feature Brief - Replies name actors by role"
summary: "Replies, reports, and Blocked lines name each actor by role. The advisory reply hook flags I and you."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Replies name actors by role

**Feature ID:** 0000521-replies-name-actors-by-role

Source: backlog entry 0000522-replies-name-actors-by-role, filed on 2026-11-11 at the human's request.

## Business Goal

On 2026-11-11 the human found "I" and "you" in agent replies subjective and confusing. A coordinator report names a step session, the coordinator, the driver, and the human. The pronouns leave the reader to work out which actor each sentence means. Replies now name each actor by role.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Actor names in the reply conventions | As the human, I read replies that name each actor by role, so that I know who acts in every sentence. | must-have | 1 |
| Reply hook flags I and you | As the human, I see an advisory note when a run reply uses "I" or "you", so that the habit stops. | must-have | 1 |
| Initiative report heading | As the human, I read the heading `Decisions for the human` in a coordinator report, so that the report follows the same rule. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, templates, hooks, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Reply conventions text | ravintio-zero | none |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown, Node.js (ES modules), Bash |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions |

## Scope Boundaries

### In Scope
- The reply conventions in `standard-boot.md`, `codex-boot.md`, the orchestrator skill, and `roadmap-standards.md`.
- The advisory reply hook `check-reply-writing.mjs`.
- The initiative skill heading and the text and test that pin it.
- Tests, an ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

### Out of Scope
- A blocking hook. The reply check stays advisory.
- Prose in documents and commit messages. The shared prose rules and `prose-check.mjs` stay as they are.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill size | The orchestrator `SKILL.md` stays at or under 9000 bytes | `test-0000247-req-001-stage-by-path.sh` |
| Hook safety | The hook exits 0 on every input | Existing suite `test-0000390-req-005-advisory-reply-check.sh` |

## Constraints and Assumptions

### Constraints
- The reply hook never blocks a turn.
- The output style keeps its second-person rule for documents. The new rule covers replies in an active run only.

### Assumptions
- A run reply opens with `hh:mm` and a run prefix. Impact if wrong: the hook skips a reply it should check.

## Scenario Paths

**Happy path:** A step reply says "the agent" and "the human". The hook prints nothing.

**First-run path:** A new install reads the rule in `CLAUDE.md`, which setup generates from `standard-boot.md`.

**Error / sad path:** A reply says "I fixed it" under a run prefix. The hook prints an advisory note and the turn still ends.

**Cross-session continuity:** A resumed session reads the same rule from `CLAUDE.md` and the skills, so the rule needs no session state.

## Acceptance Criteria

- [ ] The reply conventions in the boot templates, the orchestrator skill, and the roadmap standards name actors by role.
- [ ] The reply hook flags "I" and "you" in a reply that opens with a run prefix, and ignores other replies.
- [ ] The initiative skill heading reads `Decisions for the human`.
- [ ] The orchestrator skill stays under 9000 bytes.
- [ ] The installed copies match the source.
