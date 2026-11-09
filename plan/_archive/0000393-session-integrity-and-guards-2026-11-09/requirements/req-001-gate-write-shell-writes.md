---
title: "Requirement: REQ-001 - gate-write checks shell writes"
summary: "gate-write checks shell writes"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - gate-write checks shell writes

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000393-session-integrity-and-guards
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I want a Bash write to a gated path checked like a Write call, so that a heredoc cannot skip the design gate.

## Functional Requirements

- `gate-write.mjs` accepts a Bash tool call and reads `tool_input.command`.
- It finds write targets from `>`, `>>`, `>|`, `&>`, `tee`, and `sed -i`. It ignores heredoc bodies, quoted text, and fd duplication such as `2>&1`.
- It runs the existing checks on each target: sentinel for `plan/current/`, always-permitted paths, design present, component path match.
- It skips a target that holds a shell expansion, because the value is unknown.
- Setup wires gate-write on the Bash matcher in `setup.sh` and `setup.ps1`.
- Write and Edit behaviour does not change.

## Acceptance Criteria

- [ ] AC-1: Gated shell write blocks
  - Given a project with no `plan/current/design.md`
  - When a Bash call runs `cat > src/comp/x.js <<'EOF'` with a body
  - Then the hook exits 2 and names the missing design
- [ ] AC-2: Backlog write passes
  - Given the same project
  - When a Bash call writes to `plan/backlog/x/entry.md` with a heredoc whose body holds a line that starts with `>`
  - Then the hook exits 0
- [ ] AC-3: Write and Edit stay as they are
  - Given the existing gate-write tests
  - When they run
  - Then every one passes

## Dependencies

- ADR-001.
