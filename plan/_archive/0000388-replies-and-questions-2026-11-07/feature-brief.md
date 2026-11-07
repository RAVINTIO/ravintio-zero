---
title: "Feature Brief - Replies and questions"
summary: "Reply prefixes gain a time. The prefix warning gets clear. Agreement and question forms get firm rules."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Replies and questions

**Feature ID:** 0000388-replies-and-questions

## Business Goal

The human reads many replies and driver lines in a row during an initiative. They can't tell when each happened, they find the prefix warning confusing, and the agent treats vague replies such as "Ok" as agreement. This step adds a time to each prefix, clears up the warning, and sets firm rules for agreement and for question form.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Time before reply prefix (0000257) | As a human on the loop, I see `hh:mm` before every reply and driver line, so that I know when each happened. | must-have | 1 |
| Clear prefix warning (0000258) | As a human on the loop, I see a warning that names the check, quotes the reply, and names the session, so that I don't read it as a stopped run. | must-have | 1 |
| Explicit agreement (0000259) | As a human on the loop, I am asked for "Yes, I agree" and one permission per question, so that the agent acts only on permissions I grant. | must-have | 1 |
| Question form (0000306) | As a human on the loop, I get a choice menu for closed decisions and plain text for open questions, so that closed decisions take one click. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Hooks, scripts, skills, standards, and templates |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Pack files in `ravintio-zero/` | ravintio-zero | none |

### Integration Points

None. The hooks read the Claude Code hook payload that they read today.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (hooks and scripts), Bash and PowerShell (tests) |
| Testing | Bash suites in `ravintio-zero/tests/` with PowerShell twins |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- `check-design` injects the local time as `hh:mm`.
- `check-reply-prefix` accepts a leading `hh:mm`, and gets the 0000258 warning.
- `initiative-run.mjs` and `initiative-watch.mjs` start every line they print with `hh:mm`.
- Reply Conventions in `standard-boot.md`, the orchestrator skill, the initiative skill, and `roadmap-standards.md` name the time.
- The recommend-then-confirm rule for agreement and permissions.
- The question rule in `references/orchestrator-discovery-coaching.md`.

### Out of Scope
- The writing standard from 0000300, which step 13 creates.
- Any change to `merge-guard`, `gate-write`, or another fail-closed hook.

### Deferred
- The question rule in the writing standard. Blocked until step 13 (0000300) creates that file.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Orchestrator skill size | 9000 bytes or fewer | Existing cap test |
| Hooks | Exit 0 on every input | Existing hook tests |

## Constraints and Assumptions

### Constraints
- The `check-reply-prefix` hook warns and never blocks a turn.
- Rule text lives behind `<!-- rule: {id} -->` anchors, and tests read the anchors.

### Assumptions
- The step session sets `RAVINTIO_INITIATIVE_STEP=1`. The coordinator session does not.

## Scenario Paths

**Happy path:** The hook injects `06:43`. The agent writes `06:43 P2 Implement: Starting: x`. The prefix check passes. Driver and watcher lines start with the time.

**First-run path:** A repo with no earlier prefix misses has no miss log. The hook creates it on the first miss.

**Error / sad path:** A reply with neither time nor prefix logs a miss and shows the new warning. A reply that starts with a time and no prefix also logs a miss.

**Cross-session continuity:** The hook reads the clock on each prompt. No state carries between sessions.

## Acceptance Criteria

- [ ] `check-reply-prefix` accepts `06:43 I-C Run: Starting: x` and `06:43 P0 Discovery: Starting: x` and logs no miss.
- [ ] `check-reply-prefix` still logs a miss for a reply with neither prefix nor time.
- [ ] A driver line and a watcher line each match `^[0-2][0-9]:[0-5][0-9] ` followed by a known prefix.
- [ ] The `check-design` output holds the current local time as `hh:mm`.
- [ ] The prefix warning names "Reply prefix check", quotes the first words of the flagged reply, names the session, and doesn't read as a stopped run.
- [ ] The hook skips the check in a session without `RAVINTIO_INITIATIVE_STEP=1` while the driver lock is held.
- [ ] The recommend-then-confirm rule names "Ok" as ambiguous, asks for "Yes, I agree", and asks the human to name the option when more than one is outstanding.
- [ ] The rule asks for one permission per question, numbers each permission in a multi-permission question, and asks again when a reply names none.
- [ ] The coaching reference states the closed-question rule (choice tool) and the open-question rule (plain text), each with an example.
- [ ] The list-approval rule names the all, some, and change options, and names the text fallback for a host with no choice tool.
