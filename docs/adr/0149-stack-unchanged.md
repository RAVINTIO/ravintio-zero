---
title: "ADR 001: The stack stays as declared"
summary: "This feature adds no language, runtime, package, or test framework. It adds one Node hook, merge-guard, and one Node script, roadmap-run.mjs."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000043-autonomous-roadmaps"
---
# ADR-0149 - The stack stays as declared

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Component:** planifest-zero
**Date:** 2026-10-23

## Context

`design.md` declares the stack: Markdown skills, Node ESM scripts and hooks, Bash and PowerShell setup, Bash tests, and GitHub Actions CI. The build target is local.

This feature adds roadmap stages, a merge hook, and a chain driver. The hook must read a Bash command and a PR base before a merge runs. The driver must start child `claude -p` sessions, hold a lock, and stream one line per stage. Both jobs fit the existing Node ESM pattern that the other hooks use.

## Decision

Add no language, runtime, package, or test framework.

- **New hook.** `merge-guard` is one Node ESM file, registered as a PreToolUse hook on Bash by `setup.sh` and `setup.ps1`.
- **New script.** `planifest-zero/scripts/roadmap-run.mjs` is one Node ESM file. It uses only Node built-ins and the `claude` and `gh` command-line tools.
- **Skills and docs.** Roadmap stages, prefixes, and the carve-out text are Markdown changes to existing skills, templates, and standards.
- **Tests.** Bash tests in `planifest-zero/tests/`. Hook and driver tests call the Node files with a stub `claude` and a stub `gh` on the path.

See `plan/current/design.md` for the full stack.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Write the driver in Bash | Matches the setup scripts. No Node needed | Lock handling, build log parsing, and a Windows path need a second PowerShell copy | One Node file runs on every platform and matches the existing hooks |
| Write merge-guard in Bash | Fewer moving parts for a grep | The hook must parse quoted arguments and JSON input. Bash does this badly | Existing hooks already parse JSON in Node |
| Use a package for argument parsing or locking | Less hand-written code | A dependency in a pack that copies into consumer repos | Node built-ins cover both jobs. A package adds an install step |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | Gains one hook and one script. Setup scripts register the hook. No other runtime changes |

## Consequences

**Positive:**
- Consumer repos need no new install step. Node is already a requirement for the existing hooks.
- One Node file for each new job runs the same on macOS, Linux, and Windows.

**Negative:**
- The Node hook and script have no shared helper library, so small parsing code may repeat across hooks.
- Testing the driver needs a stub `claude`, which only approximates a real child session.

**Risks:**
- A Node version drift could break the new ESM files. The existing hooks share this risk, and CI covers it.

## Related ADRs

- ADR-0150 - related-to (storage and lifecycle use Markdown files only)
- ADR-0151 - related-to (merge-guard is the new hook)
- ADR-0152 - related-to (the driver is the new script)

## Supersedes

- None

## Superseded By

- None
