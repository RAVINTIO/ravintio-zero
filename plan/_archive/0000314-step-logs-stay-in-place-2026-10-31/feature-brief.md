---
title: "Feature Brief - step logs stay in place"
summary: "The phase guard skips the git-ignored step logs, and step sessions leave driver files where they are."
status: "approved"
version: "0.1.0"
---
# Feature Brief - step logs stay in place

**Feature ID:** 0000314-step-logs-stay-in-place

> Built from backlog entries 0000264 and 0000265 by initiative 0000312 step 2.

## Business Goal

In a step session, the git-ignored step log in `plan/.initiative-logs/` trips the phase guard, so two suites fail. A past step session moved the folder aside to avoid that, and the watcher and the driver lost their log. The guard skips the folder, and the skills tell a step session to leave driver files alone.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Phase guard skips step logs | As a step session, I run the suite with a populated step log, so that `test-0000042-req-006` and `test-0000043-req-009` pass without moving files. | must-have | 1 |
| Driver files stay in place | As an initiative owner, I want the orchestrator and initiative skills to name the driver files a step must leave alone, so that the watcher, the driver, and the coordinator keep their evidence. | must-have | 1 |

## Waves

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | Both | The tests pass and both skills name the driver files. |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The phase guard test, the orchestrator skill, and the initiative skill |

### Data Ownership

No data store.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, Markdown |
| Runtime | Bash |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Bash test scripts with `helpers/assert.sh` |
| IaC | none |
| Cloud | none |
| Compute | local |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Add `plan/.initiative-logs` to the guard's `EXCLUDE` list in `test-0000042-req-006`, and keep a planted stale cite in a tracked skill failing.
- Add a rule to the orchestrator skill and the initiative skill: a step session never moves, renames, or deletes `plan/.initiative-logs/`, `plan/.initiative-runner.lock`, or `plan/.initiative-queue/`.
- Tests that check the guard with a populated step log, the rule text, and that a full suite run leaves every step log in place.

### Out of Scope
- Scanning tracked files only. The chart rejected it, because it would hide new untracked skill files.
- Isolating other session state from the suite (step 3).
- Making a hook block moves of driver files.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | Both suites pass with a populated step log, and a planted stale cite still fails | Bash test |
| Evidence | After a full suite run, `plan/.initiative-logs/` still holds every step log | Bash test |

## Constraints and Assumptions

### Constraints
- Code and docs land together.
- The change widens no guard.

### Assumptions
- Only the phase guard test reads `plan/.initiative-logs/` as a scan target. P1 confirms this by running the full suite with a planted log.

## Scenario Paths

**Happy path:** A step session runs the suite with a populated step log. The phase guard skips the folder, and `test-0000042-req-006` and `test-0000043-req-009` pass. The folder still holds every step log afterwards.

> See above.

**First-run path:** A repo with no `plan/.initiative-logs/` folder has nothing to skip, and the guard passes as before.

> See above.

**Error / sad path:** A stale cite planted in a tracked skill still fails the guard. A stale cite inside a step log does not.

> See above.

**Cross-session continuity:** A later step session reads the rule from the installed skill and leaves driver files in place. The rule needs a setup rerun to reach the installed copies, so the initiative plans a `Setup:` stop after this step.

> See above.

## Acceptance Criteria

- [ ] `test-0000042-req-006` and `test-0000043-req-009` pass with a populated step log in `plan/.initiative-logs/`.
- [ ] A planted stale cite in a tracked skill still fails the guard.
- [ ] The orchestrator skill and the initiative skill name the driver files that a step session leaves in place.
- [ ] After a full suite run in a step, `plan/.initiative-logs/` still holds every step log.
