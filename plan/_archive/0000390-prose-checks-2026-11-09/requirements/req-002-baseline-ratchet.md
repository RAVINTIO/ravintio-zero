---
title: "Requirement: REQ-002 - Baseline ratchet"
summary: "Old breaches sit in a per-file baseline that only shrinks."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Baseline ratchet

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000390-prose-checks
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I see old breaches recorded per file, so that only new or raised counts fail and the baseline only shrinks.

## Functional Requirements
- `plan/state/prose-baseline.json` holds a count for each file and rule id.
- `check` passes a file whose count for every rule is at or below its baseline. A missing baseline file counts as empty.
- `update` lowers counts to the current values and drops files with no breach. It never raises a count. `update --init` writes the current counts when no baseline file exists.
- `diff --base <ref>` fails when any count in the working baseline is above the count at `<ref>`. It passes when `<ref>` holds no baseline file.

## Acceptance Criteria
- [ ] AC-1: baselined breach passes
  - Given a file with 2 `semicolon` breaches and a baseline of 2
  - When `check` runs
  - Then it exits 0, and a third semicolon makes it exit 1
- [ ] AC-2: update never raises
  - Given a baseline of 2 and a file that now holds 3 breaches
  - When `update` runs
  - Then the baseline stays at 2, the script exits 1, and a file that now holds 1 lowers the baseline to 1
- [ ] AC-3: raised baseline fails
  - Given a working baseline that raises one count above the base ref
  - When `diff --base HEAD` runs
  - Then it exits 1 and names the file and rule

## Dependencies
- REQ-001.
