# Changelog (0000380-test-helpers-and-rule-anchors, 07 Nov 2026)

**Feature:** Test helpers and rule anchors
**Version:** set by the merge queue at merge
**PR:** #129

## What changed

- `orch_section` returns a named section from `SKILL.md`, the orchestrator references, and the roadmap standards (0000261).
- `rule_text` and `assert_rule` read a rule by its `<!-- rule: {id} -->` anchor. `strip_rule_anchors` removes anchors before a line comparison (0000308).
- `with_timeout` in `tests/helpers/timeout.sh` caps a command on macOS, Linux, and Git Bash (0000337).
- 72 rules in the orchestrator references and the roadmap standards carry anchors.
- 16 suites read pack text through the helpers.
- Three new suites test the helpers. `testing-standards.md`, the tests README, and `component.yml` describe them.

## Why

Moving or rewording a rule broke 10 to 29 suites in earlier features. Step 19 rewrites the pack prose and would break more.

## Deviations

- `SKILL.md` carries no anchors, because it has 369 bytes under its 9000 byte cap.
- `test-0000243-req-003-004-hook-injection.sh` is unchanged. Its time limit lives inside the hook under test.
- Converting the remaining suites is filed as backlog entry 0000401.

## Validation results

- Full Bash suite: 302 feature suites and 19 regression suites passed.
- Six criteria verified by running commands. One is not verifiable locally: Git Bash on Windows, left to CI.
- Security review: two low findings, both accepted.

## Skipped phases

None
