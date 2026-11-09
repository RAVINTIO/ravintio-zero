---
title: "Feature Brief - Standards archetypes"
summary: "Override-first standards and templates, with a catalogue of four archetypes that a team picks without editing the pack."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Standards archetypes

**Feature ID:** 0000391-standards-archetypes

Built from backlog entry 0000305. Initiative 0000360 step 15 supplies it, so the chart is the approval.

## Business Goal

A team that wants a US writing style, a fixed stack, or stricter testing can edit only the pack today. Entry 0000299 makes setup refuse that edit. This step gives teams a supported path that never weakens a guard.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Override resolver | As a pack user, I put a standard or template in `ravintio-overrides/`, so that the pipeline reads my copy before the pack copy. | must-have | 1 |
| Hook-enforced rules stay | As a maintainer, I list the rules that a hook enforces, so that an override never relaxes one. | must-have | 1 |
| Archetype catalogue | As a pack user, I browse `ravintio-zero/archetypes/`, so that I see what each archetype changes. | must-have | 1 |
| Archetype use command | As a pack user, I run `setup.sh archetype use {kind}/{name}`, so that the archetype lands in my overrides and I see what it replaced. | must-have | 1 |
| Clash and threshold check | As a pack user, I pick several archetypes, so that the command reports a clash and no archetype lowers another's threshold. | must-have | 1 |
| Four starter archetypes | As a team lead, I pick US writing, restricted stack, language standards, or strict testing, so that the pipeline follows my rules. | must-have | 1 |
| Archetype gates | As a team lead, I add a constraint, so that P3 fails when a gate breaks. | must-have | 1 |
| Writing outputs from the pick | As a pack user, I pick a writing archetype, so that the output style and the `AGENTS.md` section follow it. | should-have | 1 |

## Waves

One wave. All features ship together.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Resolver, archetype catalogue, archetype command, gate check |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `ravintio-zero/archetypes/` | ravintio-zero | none |
| `ravintio-overrides/standards/`, `ravintio-overrides/templates/`, `ravintio-overrides/archetypes.json` | the consumer repo | ravintio-zero reads them |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `setup.sh` and `setup.ps1` | `scripts/archetype.mjs` | command dispatch | `archetype list` and `archetype use {kind}/{name}` |
| `writing-style.mjs` | `scripts/resolve-override.mjs` | module import | the resolver returns the path to read |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js with no packages, plus bash and PowerShell dispatch |
| Testing | bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions, as today |
| Build target | local |

## Scope Boundaries

### In Scope
- A resolver that returns an override before the pack copy for a standard or a template.
- A list of hook-enforced rules that an override cannot relax.
- `ravintio-zero/archetypes/` with a README, a manifest format, and four archetypes.
- `archetype list` and `archetype use` through `setup.sh` and `setup.ps1`.
- A clash check, a threshold check, and a gate check for P3.
- The writing outputs follow the picked writing archetype.
- Docs, component manifest, and tests.

### Out of Scope
- Installing Pact, Stryker, PIT, or Playwright MCP. The strict-testing archetype names them.
- Changing any hook so that it allows a form it blocks today.
- Rewriting existing standards (step 19 owns the prose pass).

### Deferred
- An archetype uninstall command. Nothing blocks on it, because the developer deletes the copied files by hand.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | No archetype or override relaxes a hook-enforced rule | A test plants a relaxing override and expects the pack copy |
| Determinism | The resolver and the use command give the same result on every run | Tests run twice |

## Constraints and Assumptions

### Constraints
- The orchestrator `SKILL.md` has 77 bytes of headroom under its cap. The design adds no text there.
- `setup.sh` and `setup.ps1` stay in parity.

### Assumptions
- The prose check tests no spelling, so the US archetype needs no linter change. Impact if wrong: the US archetype fails its own check.

## Scenario Paths

**Happy path:** A developer runs `setup.sh archetype use alternative/us-writing`. The command copies the files into `ravintio-overrides/`, prints each replaced pack file, and records the pick. The developer commits the result. The resolver now returns the override.

**First-run path:** No `ravintio-overrides/archetypes.json` exists. The command creates it with the first pick.

**Error / sad path:** Two archetypes claim the same slot, or one lowers a threshold. The command prints the clash, exits 1, and copies nothing.

**Cross-session continuity:** The command copies nothing until the checks pass, then writes every file and the record. A rerun of the same pick changes no file.

## Acceptance Criteria

- [ ] With an override template in `ravintio-overrides/templates/`, the resolver returns it before the pack copy.
- [ ] The resolver ignores an override that relaxes a hook-enforced rule.
- [ ] Picking two archetypes with different stack lists reports the clash and copies nothing.
- [ ] No archetype lowers the threshold of another.
- [ ] With the strict-testing archetype, the P3 gate check fails when a component API has no Pact contract.
- [ ] `archetype use` copies the files, prints what it replaced, and a rerun changes nothing.
- [ ] The output style and `AGENTS.md` section follow the picked writing archetype.
