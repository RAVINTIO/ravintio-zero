---
title: "ADR 001: Restore continuous_run exception for P1-P3 gates"
summary: "The Phase Invocation Table's P1/P2/P3 STOP rules hardcoded 'No exception', silently overriding the human's continuous_run choice at P0. Restores the exception these three phases had before a word-count trim pass (commit 42ae808, feature 0000021) dropped it, and records the corrected root-cause attribution."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000023-framework-pipeline-fixes"
---
# ADR-0093 - Restore continuous_run exception for P1-P3 gates

**Skill:** [adr-agent](../../../planifest-framework/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000023-framework-pipeline-fixes
**Component:** planifest-framework
**Date:** 2026-08-02

## Context

`planifest-orchestrator/SKILL.md`'s Phase Conventions state the general rule. Phases P1-P6 stop for human confirmation, quoted verbatim as `unless continuous_run: true was set at P0, or the phase states its own exception below`. The Phase Invocation Table's P1, P2, and P3 rows currently state their own exception as the exact text "No exception". Read against the general rule, that text cancels the `continuous_run` allowance for those three phases specifically. P4, P5, and P6 instead state an additive clean-result exception (`proceed without confirmation if all checks passed first-attempt with zero self-corrections`, etc.). That exception does not cancel the general rule. So `continuous_run` still applies there via the general rule, undisturbed.

Backlog 0000031 filed the net effect. A human who explicitly selects continuous run at P0 still faces three interruptions (after P1, P2, P3). Those stops come before the pipeline even validates Codegen output.

Backlog 0000031's own text characterized this as "a pre-existing behaviour, not introduced by feature 0000022". Its reasoning was that 0000022 `consolidated the old per-phase P1-P6 sections into the current Phase Invocation Table but explicitly preserved existing gate semantics.` That reasoning traced the wording back exactly one commit, to feature 0000021's output. It stopped there. It did not check whether 0000021 introduced the wording or merely carried it forward.

This session investigated further, at the human's explicit request, using `git show {commit}:planifest-framework/skills/planifest-orchestrator/SKILL.md` across the relevant history:

- **Commit `1eec013`** (feature 0000018) is the version in effect through the actual pipeline runs of features 0000019 and 0000020. It has each of P1 through P6 individually list `continuous_run: true was set at P0` as one of two OR-conditions to skip the stop. No "No exception" wording exists anywhere in this version.
- The actual build logs of those two runs confirm this independently. `plan/_archive/0000019-*/build-log.md` states verbatim `"continuous_run: true — proceeding to P2 without a stop-and-confirm gate"` and `"Gate note: continuous_run active, P1→P2 proceeded without stopping per orchestrator exception rule."` `plan/_archive/0000020-*/build-log.md` records the same run-mode behavior across all of P1-P6.
- **Commit `42ae808`** (feature 0000021-framework-context-bloat-audit) is where the wording changed. That feature's stated purpose was reducing word count. As part of that trim, the feature reworded all six phases' STOP lines. The multi-line P1, P2, and P3 text read `Wait for confirmation... Exceptions — proceed without confirmation if either: continuous_run: true was set at P0 / {phase-specific note}`. It collapsed to a single terse line ending in "No exception". That change silently deleted the `continuous_run` condition rather than shortening its phrasing. P4, P5, and P6 survived the same trim pass with their exception intact. Their exception clause happened to be additive to the general rule, so it did not depend on a per-phase restatement.
- **Commit `fa7f751`** (feature 0000022) then consolidated the six already-reworded sections into the current single Phase Invocation Table. It carried the already-broken P1-P3 wording forward verbatim, consistent with that feature's own explicitly stated "zero behavioural change" mandate. It was not the origin and had no reason to catch a defect it did not introduce.

There is no ADR, scope item, or build-log note in feature 0000021 announcing an intentional gating-behavior change. The evidence points to an unintended side effect of that trim. It does not point to a deliberate design choice that the team later explained poorly. That evidence has three parts. Two shipped features immediately prior worked correctly. No decision record exists. The stated goal was trimming words, not changing behavior.

## Decision

Restore the `continuous_run` exception to the P1, P2, and P3 rows of the Phase Invocation Table. Match the mechanism P4-P6 already use successfully: an explicit per-row exception clause naming `continuous_run: true` set at P0. Do not rely on the general rule alone. That reliance is exactly what broke silently here once a later edit introduced a phase-specific "No exception" override.

New STOP-rule wording for the three affected rows:

- P1 Requirements: `STOP, present requirement count/scope decisions/deferred items. Exception: continuous_run: true was set at P0.`
- P2 Architecture Decisions: `STOP, present ADR list with one-line summaries. Exception: continuous_run: true was set at P0.`
- P3 Code Generation: `STOP, present components built/tests produced/deviations. Exception: continuous_run: true was set at P0.`

This ADR leaves the P4, P5, P6, and P9 rows unchanged.

This ADR corrects Backlog 0000031's "pre-existing, not introduced by feature 0000022" claim. The regression's actual origin is commit `42ae808` (feature 0000021). It is not a long-standing quirk and not feature 0000022.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep P1-P3 as permanent always-stop gates, formalize via this ADR as a deliberate higher-stakes-gate policy | Requirements/ADRs/Codegen are arguably harder to unwind than validation/docs, so an argument for always-stopping exists in principle | No such policy was ever actually decided or requested; it would be inventing a new restriction under the guise of "recording" one, contradicting two features' worth of verified working behavior and the human's explicit intent for this very run | Not what actually happened; would be presenting an invented policy as a restored one |
| Fix only P1 and P2, leave P3 (Codegen) as an always-stop gate since code changes are higher-risk | Extra caution before code generation | Contradicts the verified pre-0000021 behavior (P3 was included in the working exception through 0000019/0000020); no incident or rationale motivates singling out P3 | Same rejection basis — this would be a new restriction, not a restoration |
| Leave the general Phase Conventions rule as the sole mechanism (remove per-row "No exception" text entirely rather than adding an explicit exception clause) | Slightly less repetitive text | This is exactly the failure mode observed: a bare general rule with no per-row restatement is one edit away from being silently overridden again, as 0000021 demonstrated | Explicit per-row restatement is the safer, already-proven pattern (it's how P4-P6 avoided the same fate) |

## Affected Components

| Component | Impact |
|-----------|--------|
| `planifest-framework` | `planifest-orchestrator/SKILL.md`'s Phase Invocation Table gains 3 corrected STOP-rule cells; no other file changes as a result of this decision |

## Consequences

**Positive:**
- `continuous_run: true` behaves consistently across all of P1-P6 again, matching verified historical behavior and the human's expectation.
- The root-cause record in this ADR gives a future contributor a concrete example for another word-count trim pass. It shows how an edit can silently delete a behavioral condition while looking like a pure rewording. This is a specific, citable precedent rather than a generic warning.

**Negative:**
- None identified. This restores previously-working, previously-relied-upon behavior. It does not introduce new behavior beyond what shipped correctly through 0000019 and 0000020.

**Risks:**
- A future prose-trimming pass over `planifest-orchestrator/SKILL.md` could reintroduce this same class of regression. It would do so if it treats the per-row exception clauses as redundant boilerplate to shorten. The general rule alone has now proved an unreliable backstop against a badly-worded per-row override. No automated guard exists against this. It remains a documentation-only safeguard.

## Related ADRs

- None. No prior ADR in this repo's history addressed `continuous_run` gate semantics directly. ADR-003 (referenced elsewhere in the orchestrator skill) covers the Scope Lock suggested-answer protocol, which is an unrelated decision.

## Supersedes

- None.

## Superseded By

- None.
