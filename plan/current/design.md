---
title: "Design - 0000380-test-helpers-and-rule-anchors"
summary: "Shared test helpers and rule anchors for the pack suites."
---
# Design - 0000380-test-helpers-and-rule-anchors

## Feature
- Problem: Tests pin skill wording and section locations, so moving or rewording a rule breaks many suites.
- Adoption mode: standard-iterative
- Feature ID: 0000380-test-helpers-and-rule-anchors
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a pack maintainer, I fetch a named section through one helper, so that moving a section fails no test.
  - US-002: As a pack maintainer, I read a rule by its `<!-- rule: {id} -->` anchor, so that rewording keeps its tests green.
  - US-003: As a test author, I cap a command with one helper line, so that the test passes on every runner.
- Acceptance criteria confirmed: 5
- Constraints: Bash 3.2, no `timeout` on macOS, `SKILL.md` byte cap of 9000
- Integrations: none

## Architecture Layer
- Latency target: helpers add under 1 second to the full suite
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no data. The helpers read pack files and run caller commands.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, Node.js, GitHub Actions, build target local
- Components: `ravintio-zero` - tests, skills, standards, and templates
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Scope
- In: `orch_section`, `rule_text`, `assert_rule`, `with_timeout`, anchors on orchestrator reference rules and roadmap standards, conversion of suites that extract orchestrator sections, docs
- Out: anchors in `SKILL.md`, regression copies, PowerShell suites
- Deferred: converting every remaining suite that pins whole sentences (backlog entry)

## Assumptions
- `perl` is present on macOS and Linux - impact if wrong: the helper uses its Bash watchdog fallback.
- Anchor text is the paragraph or list item that follows the anchor - impact if wrong: a rule split by a blank line loses its tail.

## Risks
- A converted suite asserts less than before (low likelihood, medium impact). Mitigation: keep every key term the old assertion held.
- An anchor in a template alters generated artifacts (low, low). Mitigation: anchors go in pack templates only where no generated file copies the line.

## Dependencies
- Upstream: none
- Downstream: steps 5 to 21 and step 19 read the anchors
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - section helper | ravintio-implement | Bash helper with a suite |
| REQ-002 - rule anchors | ravintio-implement | Helper, anchors, and suite conversion |
| REQ-003 - timeout helper | ravintio-implement | Bash helper with a suite |

## Repo Instructions
Local git only, prefer subagent decomposition, push and raise the PR at ship, standing setup refresh approval (`ravintio-overrides/instructions/`).

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 07 Nov 2026 @ 12:00 PM UTC
