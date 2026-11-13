---
title: "ADR-0092 - Dual-Detector Content-Loss Verification"
status: "accepted"
component: "ravintio-zero"
feature: "0000022-orchestrator-redundancy-removal"
---
﻿---
title: "ADR 002: Dual-Detector Content-Loss Verification"
summary: "This feature verifies zero enforcement-content loss with two detectors, not one. The detectors are the existing regression pack and the mandatory P4 diff review. This ADR names the review as the systematic check for what the pack does not pin. Both resolve a finding the same way - relocate the pointer or restore the content, never weaken the check."
status: "accepted"
version: "0.1.0"
---
# ADR-0092 - Dual-Detector Content-Loss Verification

**Skill:** [adr-agent](../skills/adr-agent-SKILL.md)
**Feature:** 0000022-orchestrator-redundancy-removal
**Component:** planifest-framework (skills/planifest-orchestrator)
**Date:** 2026-08-02

## Context

This feature removes and relocates roughly ten distinct content areas from `planifest-framework/skills/planifest-orchestrator/SKILL.md`. It operates under ADR-0090's mandate that a guardrailed baseline-gated trim must produce zero enforcement-content loss. The regression pack at `planifest-framework/tests/regression/` (22 tests) is the safety net that mandate assumes. Inspection at P0 estimated only 4 of the 22 tests grep or assert against orchestrator-specific content. The actual baseline run for req-001 (`plan/current/regression-baseline.md`) corrected this to 10 of 22. The P0 estimate was wrong. Even at the corrected count, no test pins three trim areas: Fast Path criteria/execution, the reversal execute/assess mechanics, and the Change Pipeline confirm questions. A cut that removes the sole statement of a rule from one of those areas would not turn the pack red. It would ship silently.

The scope-lock agent found this gap during the P0 Scope Lock Challenge, on the error/sad-path question. The human on the loop confirmed the closure. This feature's plan already requires a P4 diff review ("every removed instruction verifiably stated in exactly one canonical file") as an acceptance criterion. The plan did not name that review as a detector or give it a resolution rule for what happens when it finds a problem.

## Decision

This feature verifies content loss with two detectors, not one.

Detector 1 is the existing regression pack. It catches any orchestrator content loss that one of the 4 orchestrator-pinning tests happens to assert against.

Detector 2 is the mandatory P4 diff review already required by this feature's acceptance criteria. This ADR formally names it as the systematic detector for the remaining trim areas the regression pack does not pin. It is a full diff of every removal against the destination files, confirming each removed instruction appears in exactly one canonical file.

Both detectors resolve a finding the same way. If the content moved, update the pointer (or the test, if one exists) to the new canonical location. If the content was the sole statement of a rule and no relocation target holds it, the cut was wrong and you restore the content. Never resolve a finding from either detector by weakening or deleting a check, in either the regression pack or the diff review's own criteria.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Rely on the regression pack alone, as ADR-0090's process describes by default | No new process to define; matches the established baseline-gated trim pattern | Even at the corrected 10-of-22 count, 3 of this feature's 10 trim areas (Fast Path, reversal mechanics, Change Pipeline questions) have no automated check | Leaves a material part of this feature's scope unverified by any mechanism, defeating the zero-content-loss mandate it operates under |
| Write new regression tests to pin every content area this feature touches, so the pack alone becomes sufficient | Fully automated going forward; closes the gap with the same mechanism as Detector 1 | 3 new tests whose only purpose is to duplicate a one-time P4 diff review; adds permanent test-maintenance surface for a one-time verification need | Disproportionate for this feature; new regression tests remain the right tool for content areas future features will touch again, not for a one-time trim |
| Do the P4 diff review informally, without naming it as a detector or defining its resolution rule | No additional documentation burden; review already required by acceptance criteria | The Scope Lock Challenge specifically found the brief's error path defined resolution only for a test failure, not a diff-review finding; informal treatment leaves room for a finding to be rationalised away instead of restored | Inconsistent resolution was the exact gap surfaced by the scope-lock agent; leaving it informal does not close it |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-framework | Governs process for this feature's own P4 gate only; no code or schema change. Defines that P4 diff review findings follow the same restore-or-relocate resolution rule as regression-pack failures. |

## Consequences

**Positive:**
- Every one of the 10 content areas in scope now has an explicit, defined verification path. Existing regression tests cover only roughly 70% of them (corrected from an initial P0 estimate of 40%).
- This ADR records the resolution rule (restore the content, or relocate the pointer, and never rationalise a finding away). It is citable rather than left implicit in the acceptance criteria.

**Negative:**
- The P4 diff review is a manual, human-and-agent judgement step rather than a deterministic test. It is slower and depends on reviewer thoroughness in a way an automated regression test does not.

**Risks:**
- A rushed or incomplete diff review could still miss a lost rule in the 3 trim areas the regression pack does not pin. No deterministic gate backs Detector 2, unlike the way `ratchet-check.mjs` guards against scope-weakening elsewhere in the framework.

## Related ADRs

- ADR-0091 (agent-dispatch-standards-file) - related-to (both are P2 decisions for this same feature, with no dependency between them)
- ADR-0090 (guardrailed baseline-gated trim process) - depends-on (this ADR operates within that upstream process)

## Supersedes

- none

## Superseded By

- none
