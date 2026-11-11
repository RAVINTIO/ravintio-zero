---
title: "ADR 0317: Coordinator task scripts and a shell section"
summary: "The coordinator writes scripts with the Write tool and runs them with bash. A drain subcommand and a bulk-edit script replace improvised shell."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0317 - Coordinator task scripts and a shell section

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000474-coordinator-shell-guidance
**Component:** ravintio-zero
**File:** `docs/adr/0317-coordinator-task-scripts.md`
**Date:** 2026-11-11

## Context

From 2026-11-08 to 2026-11-10 shell snags cost the coordinator time. zsh does not split `set -- $x`. zsh reads `$b:r` as a modifier. A JavaScript `replace` with `$'` duplicated a test file. `merge-guard` and `block-forced-add` blocked compound and variable commands, as designed.

## Decision

Add a section `### Coordinator shell tasks` to the roadmap standards. It names bash and tells the coordinator to write a script with the Write tool and run it with `bash`. Add `initiative-queue.mjs drain --step {n}` to remove the items of a merged step. Add `bulk-edit.mjs`, which applies literal edits from a JSON spec file. Keep `coordinator-pr-check.mjs --base` as the overlap check. The guards stay as they are.

Oldest shell: bash 3.2

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Allow variables and compound commands in the guards | No script needed | Weakens fail-closed hooks | The guards exist to block forced adds and unreviewed merges |
| Guidance only | No code | The same snags return | The backlog entry asks for scripts |
| A new overlap script | One more entry point | Duplicates `coordinator-pr-check.mjs` | The existing script prints `overlap:` lines |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New section, a drain subcommand, and a bulk-edit script |

## Consequences

**Positive:**
- The coordinator has one documented route for repeated shell tasks.
- Bulk edits treat `$` and `&` as plain text.

**Negative:**
- The coordinator must write a script file for a task that a pipe could do.

**Risks:**
- A spec file names a path outside the repository. The script rejects such paths.

## Related ADRs

- ADR-0315 - related-to

## Supersedes

- None

## Superseded By

- None
