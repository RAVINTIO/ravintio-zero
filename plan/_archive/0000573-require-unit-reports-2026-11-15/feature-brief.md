---
title: "Feature Brief - Require unit reports"
summary: "The dispatch standard fixes the four fields of a unit report and a resume for an empty one."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Require unit reports

**Feature ID:** 0000573-require-unit-reports

## Business Goal

One dispatched unit once ended with a report that held only the word "placeholder". The orchestrator could not log its RED result and had to read the commit and rerun the suite. The dispatch standard must say what a unit report holds, so the orchestrator can reject a bad report and resume the unit.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Unit report rule | As an orchestrator, I read a unit report with a RED line, a GREEN line, a commit hash, and any deviation, so that I log the unit without rerunning the suite. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the dispatch standard |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `agent-dispatch-standards.md` | ravintio-zero | none |

## Scope Boundaries

### In Scope
- A rule in `agent-dispatch-standards.md` that fixes the four report fields.
- A rule that the orchestrator rejects a report that lacks a field and resumes the unit once.
- A test that reads the standard and expects the four fields.

### Out of Scope
- A script that checks reports.
- Changes to phase skills.

### Deferred
- Nothing deferred.

## Acceptance Criteria

- [ ] A unit that returns an empty report gets one resume.
- [ ] A test reads the standard and expects the four fields: RED line, GREEN line, commit hash, and deviation.
