---
title: "Feature Brief - Test helpers and rule anchors"
summary: "Tests find skill text through shared helpers and stable rule anchors, so moving or rewording a rule breaks no test."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Test helpers and rule anchors

**Feature ID:** 0000380-test-helpers-and-rule-anchors

## Business Goal

Moving or rewording a pack rule has broken 10 to 29 suites each time (0000243, 0000244, 0000205, 0000245). Step 19 rewrites the pack prose and would break more. Shared helpers and rule anchors let a rule move or change wording while its tests stay green. Source backlog entries: 0000261, 0000308, 0000337.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Section helper (0000261) | As a pack maintainer, I fetch a named section from `SKILL.md` and every reference file through one helper, so that moving a section fails no test. | must-have | 1 |
| Rule anchors (0000308) | As a pack maintainer, I give a rule a `<!-- rule: {id} -->` anchor and read its text through a helper, so that rewording the rule keeps its tests green. | must-have | 1 |
| Timeout helper (0000337) | As a test author, I cap a command with one helper line, so that the test passes on macOS, Linux, and Git Bash. | should-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack tests, skills, standards, and templates |

### Data Ownership

None. The pack has no data store.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, Node.js (existing) |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions (existing) |
| Build target | local |

## Scope Boundaries

### In Scope
- `orch_section` helper for named sections across `SKILL.md`, references, and the roadmap standards.
- `rule_text` and `assert_rule` helpers, and a suite that checks anchors are unique and well formed.
- `with_timeout` helper for macOS, Linux, and Git Bash, and the two tests that need a limit moved onto it.
- Anchors on the orchestrator reference rules and roadmap standards that the converted suites pin.
- The suites that extract orchestrator sections move onto the helpers.
- A `testing-standards.md` section, the tests README, and `component.yml` describe the helpers.

### Out of Scope
- Anchors in `SKILL.md` itself. The 9000 byte cap leaves 369 bytes, and later steps need them.
- Regression copies under `tests/regression/`. The ratchet guards them and the helpers stay compatible.
- PowerShell suites.

### Deferred
- Converting every other suite that pins whole sentences. A backlog entry records the remainder.
- Step 19 reads the anchors when it rewrites the prose.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Test run time | The helpers add under 1 second to the full suite | Compare the runner total before and after |

## Constraints and Assumptions

### Constraints
- Bash 3.2 on macOS, so no associative arrays and no `timeout` command.

### Assumptions
- `perl` ships on macOS and Linux. The helper falls back to a pure Bash watchdog when `perl` is absent.

## Scenario Paths

**Happy path:** A maintainer moves a rule to a reference file. The anchor travels with it and the suite stays green.

**First-run path:** A rule has no anchor yet. `rule_text` reports the missing anchor by name and the test fails.

**Error / sad path:** Two files hold the same anchor id. The anchor suite fails and names both files.

**Cross-session continuity:** The helpers hold no state. A fixed temp file replaced by rename, as `orch_combined` does, carries nothing between runs.

## Acceptance Criteria

- [ ] Moving a section between `SKILL.md` and a reference file fails no test that asserts the section's text. A heading in neither place fails.
- [ ] Moving an anchored rule to a reference file leaves its tests green.
- [ ] Rewording a rule that keeps its key terms leaves its tests green.
- [ ] Deleting a rule's anchor fails its test and names the anchor.
- [ ] A test author caps a command with one line. The helper stops a command that outlives its limit and passes one that does not.
