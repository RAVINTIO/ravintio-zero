# Changelog (0000388-replies-and-questions, 07 Nov 2026)

**Feature:** Replies and questions
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- The `check-design` hook injects the local time as `hh:mm`. The `check-reply-prefix` hook accepts a leading time before the prefix (0000257).
- Every line that `initiative-run.mjs` and `initiative-watch.mjs` print starts with `hh:mm`. The boot templates, the orchestrator and initiative skills, and the roadmap standards name the form (0000257).
- The prefix warning names "Reply prefix check", quotes the first words of the reply, and names the session. The hook skips the check in a session without `RAVINTIO_INITIATIVE_STEP=1` while the driver lock is held (0000258).
- The recommend-then-confirm rule treats "Ok" as ambiguous, asks for "Yes, I agree", and asks for one permission per question. Six rule anchors in `orchestrator-p0-coaching.md` hold it (0000259).
- The coaching reference sets the question form. Closed decisions use the choice tool, open questions use plain text, and a list approval offers all, some, and change. Five rule anchors hold it (0000306).

## Why

The human read many replies in a row with no time, found the prefix warning confusing, and saw vague replies taken as agreement.

## Deviations

- The question rule is not in the writing standard, because entry 0000300 creates that file in step 13.
- The orchestrator skill keeps a one-line time rule to stay under the 8700 byte cap in `test-0000377-req-001`.
- Three pins moved for the leading time: `test-0000189-req-003`, `test-0000205-req-006`, and `test-0000240-req-002`.

## Validation results

- Full Bash suite: 307 feature suites and 19 regression suites passed.

## Skipped phases

None
