---
title: "ADR 001: Run every hook through a launcher from the project root"
summary: "Hooks resolve from the project root and guards fail closed through guard-run.mjs."
status: "active"
version: "0.42.0"
---
# ADR-001 - Run every hook through a launcher from the project root

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000316-hooks-fail-closed
**Component:** ravintio-zero
**Date:** 2026-10-31

## Context

Setup wires hooks with paths relative to the working directory. After a `cd`, node exits 1 with `MODULE_NOT_FOUND`. Claude Code treats exit 1 as non-blocking, so the four guards allowed every call. The Claude Code docs confirm `CLAUDE_PROJECT_DIR`, `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR`, and that only exit 2 blocks a `PreToolUse` call.

## Decision

Setup sets `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` and wires every Claude Code hook as `node "${CLAUDE_PROJECT_DIR}/.claude/hooks/enforcement/guard-run.mjs" {guard|advisory} {script}.mjs`. The launcher finds the script beside itself, runs it, and in guard mode turns every failure into exit 2. Codex gets the absolute project path, since it has no project-dir variable.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Change only the paths | Small | A missing script still exits 1 and allows | Does not fail closed |
| Edit each guard to catch its own load errors | No new file | A load error happens before the guard code runs | Cannot catch it |
| Wire a shell test before node | No new file | Differs on Windows and adds quoting risk | Harder to keep in parity |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Both setup scripts, one new hook file, tests |

## Consequences

**Positive:**
- A hook runs from any directory.
- A missing or crashing guard blocks and names the script.

**Negative:**
- A guard crash now blocks work.
- A missing launcher still exits 1. The setup rerun check covers it.

**Risks:**
- The launcher adds one process start per hook call.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
