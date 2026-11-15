---
title: "Feature Brief - Coordinator starts a defined stage without asking"
summary: "The coordinator starts the stage the pipeline defines as next and asks only at a real fork or a human-only action."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Coordinator starts a defined stage without asking

**Feature ID:** 0000554-coordinator-starts-defined-stages

## Business Goal

After the last step merged, the coordinator asked "Go?" before I-E Delivery. The answer is always yes, so the question made the human wait on a decision that was not one. The standards and the initiative skill state the rule, so no session depends on a memory.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Defined-stage rule | As the human on the loop, I read a status when the coordinator starts a defined stage, so that I do not answer a question whose answer is always yes. | must-have | 1 |
| Delivery without a question | As the human on the loop, I see I-E Delivery start after the driver's clean end, so that delivery needs no prompt from me. | must-have | 1 |
| Clean-end summary | As the human on the loop, I read `action for the human: none, the coordinator runs I-E Delivery`, so that the driver does not name delivery as my action. | must-have | 1 |

## Scope Boundaries

### In Scope
- A rule `coord-defined-stage` in the coordinator questions of `roadmap-standards.md`.
- A line in the initiative skill that I-E Delivery starts with no question after a clean end.
- The new clean-end action text in `initiative-run.mjs`, `driver-stop-summary`, and the test that pins the old text.
- A test that the standards and the skill hold the new rule.

### Out of Scope
- Any change to the human-only actions. The human still merges the initiative PR into `main`.
- Any change to the stop actions for `Restart:`, `Setup:`, or other stops.

### Deferred
- Nothing deferred.

## Acceptance Criteria

- [ ] `roadmap-standards.md` holds rule `coord-defined-stage`. It says the coordinator starts a defined next stage and reports the start as a status. It asks only at a real fork or before a human-only action.
- [ ] The initiative skill says that I-E Delivery starts with no question after the driver's clean end.
- [ ] The clean-end action line reads `none, the coordinator runs I-E Delivery` when delivery is pending, in the driver, the standards, and the stop-summary test.
- [ ] A test checks that the standards and the skill hold the rule.
