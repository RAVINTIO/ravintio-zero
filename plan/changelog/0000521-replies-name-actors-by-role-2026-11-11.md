# Changelog (0000521-replies-name-actors-by-role, 11 Nov 2026)

**Feature:** Replies name actors by role
**Version:** set by the merge queue at merge
**PR:** 188

## What changed

- The reply conventions tell a reply to name each actor by role and never use "I" or "you". They sit in `standard-boot.md`, `codex-boot.md`, the orchestrator skill, and `roadmap-standards.md`.
- `check-reply-writing.mjs` gains the rule `actor-pronoun`. It flags "I", "you", and "your" in a reply that opens with `hh:mm` and a run prefix. It skips code and `>` lines, and it stays advisory.
- The coordinator report heading `Decisions for you` becomes `Decisions for the human`.
- Two new suites, `test-0000521-req-001-003` and `test-0000521-req-002`, cover the text and the hook.
- ADR 0321 records the decision.

## Why

On 2026-11-11 the human found "I" and "you" in replies subjective and confusing. A coordinator report names a step session, the coordinator, the driver, and the human, so the pronouns left the reader to guess the actor.

## Deviations

- The orchestrator skill now holds 8,937 bytes. The frozen-line test bars an edit to a base line. The change drops the examples sentence from the `Supervise:` line and adds one new line.
- The boot template cap in `test-0000151-req-011` rises from 3,800 to 4,000 bytes for the new paragraph.

## Validation results

- The new suites pass: 13 and 7 checks.
- The full suite result is in the verification report.

## Skipped phases

None.
