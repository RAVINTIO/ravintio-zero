---
title: "Feature Brief - A step session finds an unfinished step"
summary: "Resume detection prints a finding when a step session has no build log and no archive."
status: "approved"
version: "0.1.0"
---
# Feature Brief - A step session finds an unfinished step

**Feature ID:** 0000556-step-session-finds-unfinished-step

## Business Goal

A step session that ends after a queue item leaves no build log. The resume session then cannot tell where the step stands. Resume detection must name the missing P0 so the agent starts it without reading `git log` and `gh pr list`. Source: backlog entry 0000531.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Unfinished-step finding | As a step session, I read a finding that names the missing P0, so that I start P0 without piecing the state together | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds `resume-detect.mjs`, the orchestrator reference, and the tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | none | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| session start hook | `resume-detect.mjs` | stdout lines | one fixed line per finding |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js script, Bash tests |
| Testing | Bash suites in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- A finding for a step session with no `plan/current/build-log.md` and no archive folder for the feature id.
- The count of branch commits that the finding names.
- A row in the resume-detection reference and a test that pins the finding.

### Out of Scope
- Driver changes.
- Any change to what a step session does after it reads the finding, beyond the reference row.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | The script prints no repo text and always exits 0 | the existing resume-detect suite |

## Constraints and Assumptions

### Constraints
- The script prints only fixed lines and strictly validated ids.

### Assumptions
- The feature id is the branch name without the `feat/` prefix.

## Scenario Paths

**Happy path:** A step session with no build log and no archive prints the finding.

> A step session starts, finds no record, reads the finding, and starts P0.

**First-run path:** The first session of a step has no record.

> The finding prints and P0 starts. A step with a build log or an archive prints nothing new.

**Error / sad path:** The branch name or git cannot be read.

> No finding prints. The script exits 0.

**Cross-session continuity:** A session ends after commits and before a build log.

> The next session reads the commit count in the finding and starts P0.

## Acceptance Criteria

- [ ] A step session with no build log and no archive prints one finding.
- [ ] The finding is absent when a build log or an archive folder exists.
- [ ] The finding names the number of branch commits.
- [ ] The reference maps the finding to a check, and a test pins it.
