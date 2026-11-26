---
title: "Discovery - 0000579-convert-remaining-suites-to-rule-anchors"
summary: "Raw discovery-pass findings for initiative step 35."
---
# Discovery - 0000579-convert-remaining-suites-to-rule-anchors

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000579-convert-remaining-suites-to-rule-anchors`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.148.0`
- Prior features (`plan/_archive/`): 0000578 added the `Pass signal paths` section to the plan skill. 0000380 added `orch_section`, `rule_text`, `assert_rule`, and `strip_rule_anchors`.
- Constraining ADRs: none that affect rule anchors.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry 0000401. Outcome: rewording a rule in any skill, standard, or template that keeps its anchor and key terms breaks no suite.
- Helpers in `tests/helpers/assert.sh`: `orch_section` (orchestrator files and roadmap standards only), `rule_text <id>`, `assert_rule <id> <term>...`, `strip_rule_anchors`. `rule_text` reads any `.md` under `skills/`, `standards/`, or `templates/`. An anchor starts its line, after an optional list marker.
- Anchors today: 33 suites already use `assert_rule`, `rule_text`, or `orch_section`.
- Candidate scan: 206 of 464 `test-*.sh` suites read a skill, standard, or template with `assert_contains` or `grep` and use none of the three helpers. The scan over-counts. A suite that checks a file list, a line cap, or a sync result is not a pin.
- Candidate suites by target file:
  - roadmap-standards: 67
  - orchestrator: 60
  - ship: 39
  - initiative: 26
  - plan: 24
  - initiative template: 16
  - agent-dispatch-standards: 14
  - implement: 10
  - validate: 9
- Out of scope per the entry: the 21 copies in `tests/regression/`, which the ratchet process owns.
- Chart rows for the step cover fast batches and in-step pin updates.
- Other rows cover pack edits in both trees and known baseline failures.
- A docs unit logs `RED:` and `GREEN:` lines, per 0000410.
- Step 35 runs after steps 1 to 34. Step 36 (0000410) runs after it.
- Queue: no item names step 35.
- Baseline: clean-clone suite started at 2026-11-26T08:16:12Z, output in `/tmp/ravintio-s35-private/baseline.out`.
