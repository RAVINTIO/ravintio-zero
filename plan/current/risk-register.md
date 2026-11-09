---
title: "Risk Register - Light discovery and audits"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Light discovery and audits

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000387-light-discovery-and-audits
**Version:** 0.67.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The orchestrator skill passes its 9,000 byte cap | medium | low | Keep new rules in references and add short pointers only | open |
| R-002 | technical | The boot template passes its 3,600 byte cap | medium | low | Keep the edit size-neutral, or raise the cap in the same unit with a comment | open |
| R-003 | operational | A light run skips a check that a later phase needs | low | medium | The light track still writes discovery.md, design.md, and the build log | open |
| R-004 | operational | A wording pin or fixture breaks on an edited rule | medium | low | Run the full suite and update pins in the same unit | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | check-design and gate-write read design.md headings only | A light design fails the gate | open |
