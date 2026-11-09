---
title: "Requirement: REQ-001 - Light discovery track"
summary: "Light discovery track"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Light discovery track

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000387-light-discovery-and-audits
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer of a consumer repo, I want a light P0 track for fixes and small changes, so that a small change reaches a confirmed design in minutes.

## Functional Requirements

- A new orchestrator reference, `orchestrator-light-discovery.md`, defines the light track. The Pack Index in `SKILL.md` points to it.
- The reference tells the orchestrator to offer the track when the brief describes a fix or a small change. The human confirms it.
- The light track asks only for the expected behaviour, the acceptance check, and the version bump. It skips the Scope Lock Challenge and the full gate checklist. It still writes `discovery.md`, `design.md`, and the build log.
- `discovery.md` records `Track: light` or `Track: full`. A missing marker reads as full.
- If the change grows, discovery switches to the full track and logs `Track switched: light to full ({reason})`.

## Acceptance Criteria

- [ ] AC-1: Offer
  - Given a brief that describes a bug fix
  - When the orchestrator reads the light-track reference
  - Then it offers the light track and asks the human to confirm
- [ ] AC-2: Complete design
  - Given a light run
  - When the design is written
  - Then it holds every heading that gate-write and check-design read, and the discovery template holds a Track field
- [ ] AC-3: Switch
  - Given a light run that grows
  - When discovery detects the growth
  - Then it switches to the full track and logs the switch

## Dependencies

- None.
