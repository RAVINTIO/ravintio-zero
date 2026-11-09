---
title: "ADR 002: Gated and autonomous run modes"
summary: "The run modes interactive and continuous become gated and autonomous. Gated stops at the P1 to P4 gates. Autonomous stops at none and runs to a raised PR. Five exceptions stop both modes."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000042-autonomous-mode-and-prefixes"
---
# ADR-0146 - Gated and autonomous run modes

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Component:** planifest-zero
**Date:** 2026-10-23

## Context

Planifest Zero has two run modes today, `interactive` and `continuous`. Feature 0000023 set the continuous gate rules, and its tests are `test-0000023-req-001-continuous-run-p1-p3.sh` and `test-0000023-req-002-marker-commit-lifecycle.sh`. The single-route design in ADR-0110 first named continuous mode. Its archived ADR set holds no ADR for the 0000023 rules, so the tests and the skills are the record.

Continuous run skips the plan and implement gates. It still stops at acceptance and ship, so no mode reaches a pull request without stopping. The phases also run P1 to P5, while Planifest Framework starts at P0. REQ-004 to REQ-006 renumbers them P0 Discovery, P1 Plan, P2 Implement, P3 Validate and Accept, and P4 Ship.

The human chose this split: P0 stays interactive, and P1 to P4 run fully autonomous until the PR is ready for review. Continuous leaves a gap between the two modes. It stops at P3 and P4, so it is neither gated nor autonomous.

This decision supersedes the 0000023 continuous gate rules. Those rules live in the skills and tests, not in an ADR, so no ADR changes status.

## Decision

Replace `interactive` and `continuous` with `gated` and `autonomous`. No skill, doc, template, hook, or test uses the old values as run modes.

**The question.** P0 ends by asking this question, verbatim:

```
How should the agent run P1 to P4?

  [1] Gated: the agent stops for you at the end of each phase
  [2] Autonomous: the agent runs to a raised PR and stops only for escalations
```

**The file.** The orchestrator writes `gated` or `autonomous` to `plan/.run-mode` and logs the choice in the build log. No other value is valid.

**Gated.** The run stops for human confirmation at the P1, P2, P3, and P4 gates. The P4 gate comes before the PR.

**Autonomous.** The run stops at none of those gates. P3 puts its acceptance evidence in the PR description instead of a gate. P4 raises the PR and ends with `P4 Ship: Complete: PR #{n} ready for your review`. The agent never merges the PR and never commits to `main`.

**Exception stops.** Both modes stop on five exceptions:

1. A requirement or check still fails after 5 attempts.
2. P2 needs a schema change.
3. The P3 security review finds an unmitigated critical or high issue.
4. A push or `gh pr create` fails.
5. A possible credential appears in a file the run will commit, or in the PR body. P3 added this stop for security finding F-004.

Each stop prints a message that starts with `Blocked:` and names the action the human needs to take. Work stays committed and pushed. The run resumes in the same mode.

Each stop appends a `Blocked:` line to the build log, and the human's answer appends a `Resolved:` line. A resumed run does not pass an unresolved stop. P3 added this record for security finding F-002.

**Resume rule.** On resume, a missing or unknown `plan/.run-mode` makes the orchestrator ask the run-mode question. It names the value it found, or says the file is missing. It then writes the answer and logs it. A valid value restores that mode without a question. The fresh-start stale check is unchanged.

**Data ownership.** The orchestrator alone writes `plan/.run-mode`. Phase skills read it and never write it.

`pipeline-reference.md` drops the rule that let continuous skip a clean acceptance gate. The skills are the single source for gate behaviour.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep three modes like Planifest Framework: interactive, continuous, autonomous | Matches the sibling product. Keeps today's continuous users unchanged | Continuous stops at P3 and P4, so it sits between the other two. It leaves no clear gap for a human to choose | The human wants one mode per intent. P0 is interactive, then P1 to P4 is gated or autonomous. A middle mode adds a choice with no use |
| Rename only: gated and autonomous, with P3 and P4 stops kept in autonomous | Smallest change. No new P3 evidence path | Autonomous would still stop twice, so no mode reaches a PR without stopping | Fails US-001. The run must reach a PR ready for review |
| Skip only a clean P3 and keep the P4 stop | Fewer stops than today. Keeps a human check before the PR | A passing P3 gate is the only skip, so a PR still needs the human twice. The rule needs a "clean" test that the skills must define | The human merges every PR, so the PR review is the final check. A second stop before it adds no safety |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | Orchestrator, validate-and-accept, and ship skills change their gate rules. `pipeline-reference.md`, `getting-started.md`, `workflows/feature-pipeline.md`, and the two 0000023 tests change to the new values |

## Consequences

**Positive:**
- A human can start a run and return to a raised PR with no stops in between.
- Two modes with one question make the choice plain. Both modes share the same five exception stops.
- The human still reviews and merges every PR, so the final check stays.

**Negative:**
- In autonomous mode, a human sees the P3 acceptance evidence only in the PR description.
- The rename breaks any install that holds `interactive` or `continuous` in `plan/.run-mode`. The resume rule asks again and names the old value.
- The 0000023 tests keep their old feature id but assert new values, which can mislead a reader.

**Risks:**
- Autonomous hides a P3 finding until the PR. The security stop and the PR evidence reduce this risk.
- This run uses the 0.8.0 skills while it edits them. The run keeps the old numbers in its own build log.

## Related ADRs

- ADR-0145 - related-to (the change uses the existing stack)
- ADR-0110 - related-to (it first named continuous mode)

## Supersedes

- The 0000023 continuous gate rules. They sit in the skills and tests, not in an ADR.

## Superseded By

- None
