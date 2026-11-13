---
title: "Backlog Entry: 0000401 - convert remaining suites to rule anchors"
summary: "Step 4 added the helpers and anchored the orchestrator references and roadmap standards. Suites that pin other skill text still pin whole sentences."
status: "open"
priority: "medium"
theme: "tests"
---
# Backlog Entry: 0000401 - convert remaining suites to rule anchors

**Source feature:** 0000380-test-helpers-and-rule-anchors
**Source phase:** P2
**Deferral source:** deliberate scope decision
**Date filed:** 2026-11-07

---

## Problem

Step 4 anchored the rules in the orchestrator references and the roadmap standards, and moved the suites that cut orchestrator sections onto `orch_section` and `assert_rule`. About 140 other suites still pin whole sentences from other skills, standards, and templates. Rewording those files breaks them, and step 19 rewrites most of them.

## Suggested Action

- Give each rule that a suite pins in the ship, plan, implement, validate, and initiative skills, and in the standards and templates, a `<!-- rule: {id} -->` anchor.
- Move those suites onto `assert_rule` with key terms. Leave `tests/regression/` copies to the ratchet process.
- Run this before or inside step 19.

## Wanted outcome

Rewording a rule in any skill, standard, or template that keeps its anchor and key terms breaks no suite.

## Why Deferred

Converting every suite is larger than one step. Step 4 delivered the helpers and the orchestrator conversion.
