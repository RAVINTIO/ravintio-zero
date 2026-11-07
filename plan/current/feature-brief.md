---
title: "Feature Brief - Driver stops and headroom"
summary: "The driver stops on a Question line and checks for a Setup stop after the last step. The orchestrator skill gains byte headroom."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Driver stops and headroom

**Feature ID:** 0000377-driver-stops-and-headroom

## Business Goal

An unattended initiative must not hide a human question or ship stale installed skills. Today the driver resumes a step that ends on `Question:` and hides the question behind a `Blocked:` line. The driver also skips the `Setup:` stop after the last step. The orchestrator skill has 118 bytes left under its 9000 byte cap, which blocks the next rule.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Context Hygiene to a reference (0000371) | As a pack maintainer, I move Context Hygiene out of the orchestrator `SKILL.md`, so that later steps can add rules under the 9000 byte cap. | must-have | 1 |
| Driver stops on Question (0000370) | As the human on the loop, I see the driver stop at once on an unresolved `Question:` line, so that no step guesses an answer only I can give. | must-have | 1 |
| Setup check after the last step (0000373) | As the human on the loop, I see a `Setup:` stop before `I-E Delivery: Pending:`, so that delivery runs on current installed skills. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack of standards, skills, hooks, scripts, and tests |

### Data Ownership

None. The step writes no data store.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `initiative-run.mjs` | step log and `build-log.md` | file read | Stop lines in `roadmap-standards.md` |
| `initiative-watch.mjs` | `build-log.md` | file read | Event lines |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node (ESM, no packages), Bash, PowerShell |
| Testing | Shell test scripts in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Move Context Hygiene from `ravintio-zero/skills/ravintio-orchestrator/SKILL.md` to `references/orchestrator-context-hygiene.md` and add a Pack Index row. Update the cap tests and the base fixture that read the moved text.
- Treat an open `Question:` line like `Blocked:` in the driver and the watcher. Stop with no resume and repeat the question in the stop line.
- Name `Question:` in the continue prompt.
- Run the setup change check after the last step and print the `Setup:` line before `I-E Delivery: Pending:`.
- Update `roadmap-standards.md`, the docs, and the tests for each change.

### Out of Scope
- Parallel steps, merge-time versioning, and any other step of initiative 0000360.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill size | Orchestrator `SKILL.md` at most 8700 bytes | `wc -c` in the cap tests |

## Constraints and Assumptions

### Constraints
- Cap tests keep their 9000 byte limit.
- The driver changes while it runs, so the coordinator takes the `Restart:` stop (chart decision).

### Assumptions
- A `Question:` line in the build log is the signal, as `Blocked:` is today.

## Scenario Paths

**Happy path:** A step writes `Question:` to the build log and ends its turn. The driver stops, prints the question, and exits 1 with no resume.

> Driver prints `I-C Run: Blocked: step {n} stopped. {Question line}`.

**First-run path:** A build log with no `Question:` line behaves as today.

> No change.

**Error / sad path:** A `Question:` line followed by a `Resolved:` line does not stop the driver.

> Same rule as `Blocked:`.

**Cross-session continuity:** The stop reads the build log on disk, so a restarted driver sees the same open question.

> Nothing is held in memory.

## Acceptance Criteria

- [ ] AC-1: Orchestrator `SKILL.md` has no Context Hygiene section, has a Pack Index row for `references/orchestrator-context-hygiene.md`, and is at most 8700 bytes. The reference file holds the moved text.
- [ ] AC-2: A step log whose build log ends on an open `Question:` makes the driver stop with no resume and print the question. A later `Resolved:` line clears it.
- [ ] AC-3: The watcher reports an open `Question:` line.
- [ ] AC-4: The continue prompt names `Question:` as a valid place to end a turn.
- [ ] AC-5: When the last step changes a pack file that setup installs, the driver prints the `Setup:` line and exits 1 before `I-E Delivery: Pending:`.
- [ ] AC-6: `roadmap-standards.md` and the driver and watcher header comments describe all three behaviours. The full suite passes.
