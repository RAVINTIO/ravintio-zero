---
title: "Requirement: REQ-001 - Shell version check"
summary: "The plan check flags an ADR that picks a Bash 4 feature with no oldest-shell line."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Shell version check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000384-plan-checks
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I want the plan check to flag a shell feature that Bash 3.2 lacks, so that P2 does not rework the design.

## Functional Requirements
- The plan skill ADR rules tell the planner to name the oldest supported shell for an ADR that picks a shell feature.
- `consistency-check.mjs` check 9 scans each ADR for a listed Bash 4 or later feature: `command_not_found_handle`, `declare -A`, `mapfile`, `readarray`, `coproc`, `globstar`, `wait -n`, `${var,,}`, `${var^^}`, `&>>`, and `|&`.
- An ADR that names a listed feature passes only if it also holds a line that starts `Oldest shell:`.

## Acceptance Criteria
- [ ] AC-1: Unlisted shell version fails
  - Given an ADR that names `command_not_found_handle` and has no `Oldest shell:` line
  - When `consistency-check.mjs` runs
  - Then it exits 1 and names the ADR and the feature
- [ ] AC-2: Named shell version passes
  - Given the same ADR with the line `Oldest shell: Bash 3.2, feature checked absent, fallback chosen`
  - When `consistency-check.mjs` runs
  - Then check 9 reports no finding

## Dependencies
- None
