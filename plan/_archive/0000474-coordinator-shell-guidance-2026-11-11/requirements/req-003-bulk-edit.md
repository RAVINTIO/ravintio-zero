---
title: "Requirement: REQ-003 - Bulk edit script"
summary: "A script applies literal text edits listed in a JSON spec file."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Bulk edit script

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000474-coordinator-shell-guidance
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I run scripts for repeated tasks, so that I never improvise a compound command.

## Functional Requirements
- `node ravintio-zero/scripts/bulk-edit.mjs {spec.json} [--root dir] [--dry-run]` applies the edits in the spec.
- The spec is `{ "edits": [ { "file": "path", "from": "text", "to": "text" } ] }`. The coordinator writes it with the Write tool.
- Each edit replaces every literal occurrence of `from` with `to`. It treats `$`, `&`, and backslashes in `to` as plain text.
- The script prints `edited: {file} ({count})` for each file it changes, and `unchanged: {file}` when `from` is absent.
- It rejects an absolute path, a `..` segment, a symlink, and an empty `from`. It exits 1 and writes nothing when any edit fails the checks.
- With `--dry-run`, it prints the same lines and writes nothing.
- It exits 2 on a missing or malformed spec.

## Acceptance Criteria
- [ ] AC-1: Literal replacement
  - Given a file with `a` and a spec that replaces `a` with `$'x$&`
  - When the script runs
  - Then the file holds `$'x$&` exactly once per match and no duplicated text
- [ ] AC-2: Unsafe path
  - Given a spec with a `..` path
  - When the script runs
  - Then it exits 1 and changes no file
- [ ] AC-3: Dry run
  - Given a valid spec
  - When the script runs with `--dry-run`
  - Then it prints the `edited:` lines and the files stay as they were

## Dependencies
- None
