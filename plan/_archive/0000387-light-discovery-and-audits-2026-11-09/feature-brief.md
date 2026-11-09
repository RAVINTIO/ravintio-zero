---
title: "Feature Brief - Light discovery and audits"
summary: "A light P0 track, grouped coaching commits, and three coaching and audit checks."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Light discovery and audits

**Feature ID:** 0000387-light-discovery-and-audits

## Business Goal

P0 takes most of a consumer run's time, and two late-found problems stopped runs in P1 and P2. This step adds a light P0 track for small work and groups coaching records into fewer commits. It also makes discovery and plan catch bad criteria and late advisories before the plan gate.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Light discovery track (0000281) | As a maintainer of a consumer repo, I want a light P0 track for fixes and small changes, so that a small change reaches a confirmed design in minutes. | must-have | 1 |
| Grouped coaching commits (0000284) | As a maintainer, I want coaching records grouped by topic, so that P0 history shows a few topic commits. | must-have | 1 |
| Content check before criteria (0000348) | As a maintainer, I want discovery to check that tested content exists, so that no criterion tests nothing. | must-have | 1 |
| Audit refresh at plan (0000328) | As a maintainer, I want the plan phase to re-run the dependency audit, so that a late advisory stops at the plan gate. | must-have | 1 |
| Major bump approval (0000329) | As a maintainer, I want coaching to ask whether a major bump is pre-approved, so that an advisory fix does not stop P2. | must-have | 1 |

## Target Architecture

One component, `ravintio-zero`: skills, references, templates, and tests. No data store and no integration.

## Scope Boundaries

### In Scope
- Light track reference, offer, switch to the full track, and a track marker in `discovery.md`.
- Commit grouping rule in the orchestrator skill and the boot template.
- Coaching rules for criterion content checks and major-bump approval.
- Audit re-run step in `ravintio-plan` and the `Audit:` build-log line.

### Out of Scope
- Any change to a hook, guard, or script.

### Deferred
- Nothing deferred.

## Acceptance Criteria

- [ ] The orchestrator offers the light track for a fix or small change, and a light design passes `gate-write` and `check-design`.
- [ ] A light run that grows switches to the full track and logs the switch.
- [ ] The orchestrator states which records group into one commit and still commits each requirement, ADR, and `design.md` at once.
- [ ] Coaching checks that one instance exists before it confirms a criterion about existing content, and offers a reworded criterion if none does.
- [ ] `ravintio-plan` re-runs the audit before the plan gate for advisory or version requirements, logs `Audit: re-run at P1 ({result})`, and stops on a fix outside the approved list.
- [ ] Coaching asks whether a major bump is pre-approved for an advisory fix and records the answer in `Approved dependencies`.
