---
title: "ADR 004: A sixth exception stop for unapproved dependencies"
summary: "Every run gains a sixth exception stop when P1 or P2 adds a library or service that is missing from the approved list."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000151-hardening-efficiency-and-ci"
---
# ADR-0159 - A sixth exception stop for unapproved dependencies

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Component:** planifest-zero
**Date:** 2026-10-24

## Context

The orchestrator has five exception stops. None of them covers a new library or service. A headless roadmap step can add a dependency that no human reviewed, and an interactive run can do the same.

The approved list has two homes. `design.md` holds an `Approved dependencies` field for the feature. In a roadmap, `roadmap.md` holds a `## Dependencies` table that Chart fills and the human approves. The human chose to apply the stop in every run, not only in roadmap runs.

## Decision

Add a sixth row to the Exception Stops table in the orchestrator skill.

- **Trigger.** P1 or P2 adds a library or service that is not on the approved list.
- **List.** `design.md` "Approved dependencies" in an interactive run. `roadmap.md` "## Dependencies" in a roadmap step.
- **Message.** `{prefix} Blocked: new dependency {name} is not on the approved list. Approve it or choose an approved alternative.`
- **Flow.** The row follows the shared stop steps, including the `Blocked:` and `Resolved:` build-log lines. On approval, the run adds the name to the same list.
- **Scope.** Both run modes. The five original rows stay byte-identical.

`planifest-implement` and `planifest-plan` mirror the wording.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Roadmap runs only | Fewer interruptions in interactive work | An interactive run can add an unreviewed dependency | The human chose every run |
| Warn in the build log, do not stop | No interruption | Nobody reads the log until the PR | A warning does not prevent the unreviewed addition |
| Ask a fallback question at Chart | Catches more at chart time | Adds questions that the human wants fewer of | A dependency that no row lists stops the step, which is cheaper |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | Orchestrator, implement, and plan skills gain the stop. Roadmap standards, the roadmap entry template, and the design template gain the list |

## Consequences

**Positive:**
- No run adds a library or service that a human has not approved.
- The approval is recorded in a `Resolved:` line.

**Negative:**
- An interactive run can stop for a dependency the human considers trivial.
- Chart takes longer, because it predicts and lists dependencies.

**Risks:**
- Chart may miss a dependency, so a step stops later. The stop is the safety net.
- A step could add a dependency under a different name from the list. The human resolves it at the stop.

## Related ADRs

- ADR-0161 - related-to (the Exception Stops table stays inline in `SKILL.md`)

## Supersedes

- None

## Superseded By

- None
